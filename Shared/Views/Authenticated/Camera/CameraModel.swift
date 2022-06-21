
import SwiftUI
import AVFoundation
import JWTDecode
import Foundation
import MediaPlayer


class CameraModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate, AVCaptureFileOutputRecordingDelegate{
    
    
    var user = UserFetchServiceResultModel()
    
    
    enum CameraFacing {
        case front
        case back
        
    }
    
    
    @Published var postUploadData = PostUploadData()
    
    
    @Published var isTaken = false
    
    @Published var session = AVCaptureSession()
    
    @Published var videoDeviceInput: AVCaptureDeviceInput!
    
    
    @Published var alert = false
    
    // since were going to read pic data....
    @Published var output = AVCapturePhotoOutput()
    @Published var outputMovie = AVCaptureMovieFileOutput()
    
    
    // preview....
    @Published var preview : AVCaptureVideoPreviewLayer!
    
    // Pic Data...
    
    @Published var isSaved = false
    
    @Published var picData = Data(count: 0)
    @Published var movieData = Data(count: 0)
    
    
    @Published var flashMode: AVCaptureDevice.FlashMode = .on
    @Published var cameraFacingPosition = CameraFacing.back
    
    // MARK: Video Recorder Properties
    @Published var isRecording: Bool = false
    @Published var recordedURLs: [URL] = []
    @Published var previewURL: URL?
    @Published var showPreview: Bool = false
    @Published var movieFile: URL?
    @Published var showMoviePreview: Bool = false
    
    
    // Top Progress Bar
    @Published var recordedDuration: CGFloat = 0
    // YOUR OWN TIMING
    @Published var maxDuration: CGFloat = 15
    @Published var isCameraReady = false
    
    
    
    
    
    
    func Check()  {
        
        // first checking camerahas got permission...
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setUp()
            return
            // Setting Up Session
        case .notDetermined:
            // retusting for permission....
            AVCaptureDevice.requestAccess(for: .video) { (status) in
                
                if status{
                    self.setUp()
                }
            }
        case .denied:
            self.alert.toggle()
            return
            
        default:
            return
        }
    }
    
    func setUp(){
        
        
        
        print("checking camera ......")
        // setting up camera...
        
        do{
            
            // setting configs...
            self.session.beginConfiguration()

            
            // change for your own...
            
            let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
            
            let videoDeviceInput = try AVCaptureDeviceInput(device: device!)
            
            let audioDevice = AVCaptureDevice.default(for: .audio)
            let audioInput = try AVCaptureDeviceInput(device: audioDevice!)
            
            // checking and adding to session...
            DispatchQueue.main.async {
                if self.session.canAddInput(videoDeviceInput) && self.session.canAddInput(audioInput){
                    self.session.addInput(videoDeviceInput)
                    self.session.addInput(audioInput)
                    self.videoDeviceInput = videoDeviceInput
                    
                    
                }
                
                // same for output....
                
                if self.session.canAddOutput(self.output) && self.session.canAddOutput(self.outputMovie){
                    self.session.addOutput(self.output)
                    self.session.addOutput(self.outputMovie)
                    
                }
                
                self.session.commitConfiguration()
                
                self.isCameraReady = true
                print(self.isCameraReady, "is camera ready to true")
            }
            
            
            
       

        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    
    func toggleFlash() {
        
        print("TOGGLE FLASH")
        
        
    }
    
    
    func flipCamera() {
        
        // setting up camera...
        let currentVideoDevice = self.videoDeviceInput.device
        let currentPosition = currentVideoDevice.position
        
        let backVideoDeviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera, .builtInDualWideCamera, .builtInWideAngleCamera],
                                                                               mediaType: .video, position: .back)
        let frontVideoDeviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInTrueDepthCamera, .builtInWideAngleCamera],
                                                                                mediaType: .video, position: .front)
        var newVideoDevice: AVCaptureDevice? = nil
        
        
        
        
        switch currentPosition {
        case .unspecified, .front:
            newVideoDevice = backVideoDeviceDiscoverySession.devices.first
            self.cameraFacingPosition = CameraFacing.front
            
        case .back:
            newVideoDevice = frontVideoDeviceDiscoverySession.devices.first
            self.cameraFacingPosition = CameraFacing.back


            
            
        @unknown default:
            print("Unknown capture position. Defaulting to back, dual-camera.")
            newVideoDevice = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back)
        }
        
        print("CURRENT POSITION", self.cameraFacingPosition)

        
        if let videoDevice = newVideoDevice {
            do {
                let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
                
                self.session.beginConfiguration()
                
                // Remove the existing device input first, because AVCaptureSession doesn't support
                // simultaneous use of the rear and front cameras.
                self.session.removeInput(self.videoDeviceInput)
                
                if self.session.canAddInput(videoDeviceInput) {
                    NotificationCenter.default.removeObserver(self, name: .AVCaptureDeviceSubjectAreaDidChange, object: currentVideoDevice)
                    NotificationCenter.default.addObserver(self, selector: #selector(self.subjectAreaDidChange), name: .AVCaptureDeviceSubjectAreaDidChange, object: videoDeviceInput.device)
                    
                    self.session.addInput(videoDeviceInput)
                    self.videoDeviceInput = videoDeviceInput
                } else {
                    self.session.addInput(self.videoDeviceInput)
                }
                
                
                
                
                self.session.commitConfiguration()
            } catch {
                print("Error occurred while creating video device input: \(error)")
            }
        }
    }
    
    @objc
    func subjectAreaDidChange(notification: NSNotification) {
        let devicePoint = CGPoint(x: 0.5, y: 0.5)
        //        focus(with: .continuousAutoFocus, exposureMode: .continuousAutoExposure, at: devicePoint, monitorSubjectAreaChange: false)
    }
    
    // take and retake functions...
    
    func takePic() {
        self.picData = Data(count: 0)
        
        self.isTaken = true
        
        DispatchQueue.main.async {
            self.isTaken = true
            
            self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
            DispatchQueue.main.async {
                Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { (timer) in
                    self.session.stopRunning()
                }
            }
            
            
            print("pic taken...")
        }
        
    }
    
    func startRecording(){
        self.previewURL = nil
        
        // MARK: Temporary URL for recording Video
        let tempURL = NSTemporaryDirectory() + "\(Date()).mov"
        print("TEMP URL ----->", tempURL)
        outputMovie.startRecording(to: URL(fileURLWithPath: tempURL), recordingDelegate: self)
        isRecording = true
    }
    
    func stopRecording(){
        print("STOP RECORDING")
        outputMovie.stopRecording()
        isRecording = false
    }
    
    func reTake(){
        
        DispatchQueue.global(qos: .background).async {
            
            self.session.startRunning()
            
            DispatchQueue.main.async {
                withAnimation{self.isTaken.toggle()}
                //clearing ...
                self.isSaved = false
               
                self.showMoviePreview = false
                self.recordedDuration = 0
                self.recordedURLs.removeAll()
                
                
            }
        }
    }
    
    
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        
        
        if error != nil{
            return
        }
        
        print("pic taken...")
        
        
        
        guard let imageData = photo.fileDataRepresentation() else{return}
  
        self.picData = imageData
        
        
        
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            print("FILE OUTPUT ERROR ----->", error.localizedDescription)
            return
        }
        
        // CREATED SUCCESSFULLY
        
        self.recordedURLs.append(outputFileURL)
        
        
        self.previewURL = outputFileURL
        
        do {
            
            
            let data = try Data(contentsOf: self.previewURL!)
            print("DATA FOR MOVIE FILE ----->", data)
            
        } catch {
            print(error)
        }
        
        do {
            let data = try NSData(contentsOf: outputFileURL, options: NSData.ReadingOptions())
            self.movieData = data as Data
        } catch {
            print(error)
        }
        
        
        
        
        
        // CONVERTING URLs TO ASSETS
        let assets = recordedURLs.compactMap { url -> AVURLAsset in
            return AVURLAsset(url: url)
        }
        
        
        
        
        self.showMoviePreview = true
        self.isTaken = true
        
        
    }
    
    
    
    func saveVideo() async {
        
        reTake()
        
        
        
        
        let credentials = KeychainStorage.getCredentials()
        let accessToken = credentials?.AccessToken
        let url = URL(string: "\(API_URL)/post/getUploadUrl")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(accessToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        let body: [String: AnyHashable] = [
            "fileExtension": "mov",
            "type": "video"
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        do {
            let (data, _) = try! await URLSession.shared.data(for: request)
            self.postUploadData = try JSONDecoder().decode(PostUploadData.self, from: data)
            
            
            
            
        } catch {
            debugPrint("Error loading \(url): \(String(describing: error))")
        }
        
        
        
        
        // upload to s3 bucket
        let uploadUrl = URL(string: postUploadData.url!)!
        var requestToUpload = URLRequest(url: uploadUrl)
        requestToUpload.setValue("video/mov", forHTTPHeaderField: "Content-Type")
        //        request.setValue(accessToken, forHTTPHeaderField: "Authorization")
        requestToUpload.httpMethod = "PUT"
        
        
        print("MOVIE DATAA ----->", self.movieData)
        
        
        requestToUpload.httpBody = self.movieData
        do {
            let (data, _) = try! await URLSession.shared.data(for: requestToUpload)
            
        } catch {
            debugPrint("Error loading \(url): \(String(describing: error))")
        }
        
        
        
    }
    
    
    
    func savePic() async {
        
        
        
      
      

        
        
        
        
        reTake()
        
        
        
        
        
        let credentials = KeychainStorage.getCredentials()
        let accessToken = credentials?.AccessToken
        let url = URL(string: "\(API_URL)/post/getUploadUrl")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(accessToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        let body: [String: AnyHashable] = [
            "fileExtension": "jpeg",
            "type": "image"
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        do {
            let (data, _) = try! await URLSession.shared.data(for: request)
            self.postUploadData = try JSONDecoder().decode(PostUploadData.self, from: data)
            
            
            
            
        } catch {
            debugPrint("Error loading \(url): \(String(describing: error))")
        }
        
        
        
        
        // upload to s3 bucket
        let uploadUrl = URL(string: postUploadData.url!)!
        var requestToUpload = URLRequest(url: uploadUrl)
        requestToUpload.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")
        requestToUpload.httpMethod = "PUT"
        
//        print("OUTPUT", self.output)
//        print("PIC DATAA ----->", self.picData)
        
        let image = UIImage(data: self.picData,scale: 1.0)
        let compresseImageData =  image!.jpegData(compressionQuality: 0.55)

        requestToUpload.httpBody = compresseImageData
        do {
            let (data, _) = try! await URLSession.shared.data(for: requestToUpload)
            //            self.userData.profilePictureUrl = uploadProfilePicture.profilePictureUrl
        } catch {
            debugPrint("Error loading \(url): \(String(describing: error))")
        }
        
        
        
        
        
        
    }
    
    
    struct PostUploadData: Codable {
        var url: String?
        
    }
    
}

// setting view for preview...

struct CustomCameraPreview: UIViewRepresentable {
    
    @ObservedObject var camera : CameraModel
    
    func makeUIView(context: Context) ->  UIView {
        
        let view = UIView(frame: UIScreen.main.bounds)
        
        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
        camera.preview.frame = view.frame
        
        // Your Own Properties...
        camera.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(camera.preview)
        
        // starting session
        
        camera.session.startRunning()
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}
