//
//  ContentView.swift
//  Shared
//
//  Created by Balaji on 12/12/20.
//

import SwiftUI
import AVKit

import AVFoundation
import JWTDecode
import Foundation



struct CustomCameraView: View {
    
    
    @EnvironmentObject var camera: CameraModel
    @State private var player = AVPlayer(url: URL(string: "https://media.w3.org/2010/05/sintel/trailer.mp4")!)
    @Binding var currentTab: Int
    
    
    
    var body: some View {
        
        
        if camera.isCameraReady {
            ZStack{
                
                
                
                
                CustomCameraPreview(camera: camera)
                
                
               
                
               
                
                
                
                
                if camera.showMoviePreview {
                    
                    
                    PlayerView(player: $player)
                    
                        .onAppear {
                            player = AVPlayer(url: camera.previewURL!)
                            player.play()
                        }
                        .onDisappear {
                            player.seek(to: .zero)
                            player.pause()
                            
                        }
                        .rotation3DEffect(.degrees(camera.cameraFacingPosition != .front ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                    
                    //
                    //                    CustomVideoPlayer(url: camera.previewURL)
                    //                        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                    //                        .onDisappear {
                    //
                    //
                    //                        }
                    
                    
                }
                
                
                CameraControls(currentTab: $currentTab)
                
            }
            .onTapGesture(count: 2) {
                camera.flipCamera()
            }
            .background(.yellow)
    //        .onAppear(perform: {
    //            camera.Check()
    //            camera.setUp()
    //
    //        })
            
            //        .navigationTitle("kjladsf")
            .alert(isPresented: $camera.alert) {
                Alert(title: Text("Please Enable Camera Access"))
            }
            .zIndex(5)
        } else {
            ZStack {
                
            }
            .frame(minWidth: 100, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
            .background(.black)
            
        }
        
        
       
    }
}






struct CameraControls: View {
    @Binding var currentTab: Int
    
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @EnvironmentObject var camera: CameraModel
    @EnvironmentObject var user: UserFetchServiceResultModel
    @EnvironmentObject var inbox: InboxServiceModel
    
    
    
    
    @State var animate = false
    @State var progressValue: Float = 0.0
    @State var showGrid = false
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State var beginRecording = false
    
    var topSafeAreaHeight: CGFloat = 0
    var bottomSafeAreaHeight: CGFloat = 0
    
    
    
    func getTopSafeAreaInset() -> CGFloat {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let topPadding = window?.safeAreaInsets.top
        return topPadding!
    }
    
    
    
    var body: some View {
        
        GeometryReader { geo in
            
            if showGrid {
                Grid()
            }
            
            
            if !camera.isTaken {
                
                
                VStack {
                    //                    Spacer()
                    HStack{
                        
                        Spacer()
                        if !camera.isRecording {
                            
                            
                            
                            VStack(spacing:20) {
                                
                                
                                Button {
                                    
                                    camera.toggleFlash()
                                } label: {
                                    VStack(spacing: 2) {
                                        Image(systemName: "bolt")
                                            .foregroundColor(.white)
                                            .font(.system(size: 28))
                                            .shadow(color: Color.black.opacity(0.4), radius: 2, x: 0, y: 0.5)
                                        
                                        
                                        Text("Flash")
                                            .font(.caption2).bold()
                                            .foregroundColor(.white)
                                            .shadow(color: Color.black.opacity(0.7), radius: 2, x: 0, y: 0.5)
                                        
                                    }
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                }
                                
                                
                                Button {
                                    
                                    
                                    camera.flipCamera()
                                } label: {
                                    VStack(spacing: 2) {
                                        
                                        
                                        Image(systemName: "arrow.triangle.2.circlepath")
                                            .foregroundColor(.white)
                                            .font(.system(size: 24))
                                            .shadow(color: Color.black.opacity(0.4), radius: 2, x: 0, y: 0.5)
                                        
                                        
                                        Text("Flip")
                                            .font(.caption2).bold()
                                            .foregroundColor(.white)
                                            .shadow(color: Color.black.opacity(0.7), radius: 2, x: 0, y: 0.5)
                                        
                                        
                                        
                                    }
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                }
                                
                                
                                Button {
                                    
                                    
                                    self.showGrid.toggle()
                                } label: {
                                    VStack(spacing: 2) {
                                        
                                        
                                        Image(systemName: "squareshape.split.2x2")
                                            .foregroundColor(.white)
                                            .font(.system(size: 26))
                                            .shadow(color: Color.black.opacity(0.4), radius: 2, x: 0, y: 0.5)
                                        
                                        
                                        Text("Grid")
                                            .font(.caption2).bold()
                                            .foregroundColor(.white)
                                            .shadow(color: Color.black.opacity(0.7), radius: 2, x: 0, y: 0.5)
                                        
                                        
                                        
                                    }
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                }
                                
                                
                            }
                            .padding(.top, getTopSafeAreaInset())
                            
                            
                            
                            //                            .padding(safeAreaInsets)
                            
                        }
                        
                        
                        
                    }
                    
                    .padding(.trailing, 15)
                    
                    
                    Spacer()
                    
                    HStack(alignment: .center) {
                        
                        
                        ZStack (alignment: .center){
                            
                            
                            
                            Image(systemName: "circle")
                                .font(.system(size:  80, weight: .semibold))
                                .scaleEffect(animate ? 1.25 : 1)
                                .foregroundColor(animate ? Color.white.opacity(0) : Color.white.opacity(0.98))
                                .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 0.5)
                            //you can change the animation you need
                            
                            
                            
                            ProgressBar(progress: self.$progressValue)
                                .frame(width: 90, height: 90)
                                .scaleEffect(animate ? 1.37 : 0)
                            
                            
                            Image(systemName: "circle.fill")
                                .font(.system(size:  80, weight: .semibold))
                                .scaleEffect(animate ? 1.25 : 0)
                                .foregroundColor(Color.white.opacity(0.5))
                            
                            //you can change the animation you need
                            
                            
                            
                            Image(systemName: "square.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.pink)
                                .scaleEffect(animate ? 1 : 0)
                            
                            
                            
                        }
                        .onReceive(timer) { _ in
                            if camera.isRecording {
                                progressValue += 0.1 / 15
                                
                            }
                            
                            
                            
                            
                            if camera.isRecording && progressValue > 1 {
                                camera.stopRecording()
                                withAnimation(.easeInOut(duration: 0.1)) {
                                    self.animate.toggle()
                                }
                                self.progressValue = 0
                            }
                            
                        }
                        
                        
                        .onTapGesture {
                            if !camera.isRecording {
                                camera.takePic()
                                self.animate = false
                                
                            } else {
                                withAnimation(.easeInOut(duration: 0.1)) {
                                    self.animate = false
                                }
                                camera.stopRecording()
                                self.progressValue = 0
                                
                            }
                        }
                        
                        
                        .onLongPressGesture(minimumDuration: 0, maximumDistance: 50, pressing: { (isPressing) in
                            if isPressing {
                                withAnimation(.easeInOut(duration: 0.1)) {
                                    self.animate = true
                                }
                                
                                
                                
                                // called on touch down
                            } else {
                                // called on touch up
                                //                                        print = "TAP"
                            }
                        }, perform: {
                            
                            camera.startRecording()
                            
                        })
                        
                        
                        
                        
                        .padding([.bottom], 140 + geo.safeAreaInsets.bottom )
                        
                        
                        
                        
                    }
                    
                }
                
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .padding(.top, topSafeAreaHeight + 20 )
            }
            
            if camera.isTaken {
                
                VStack {
                    Spacer()
                    HStack {
                        
                        Button(action: camera.reTake, label: {
                            
                            ZStack {
                                
                                Image(systemName: "circle.fill")
                                
                                
                                
                                    .foregroundColor(.white)
                                    .font(.system(size: 42, weight: .bold))
                                Image(systemName: "xmark.circle.fill")
                                
                                
                                
                                    .foregroundColor(.secondary)
                                    .font(.system(size: 42, weight: .bold))
                                    .padding(.horizontal,20)
                                    .clipShape(Capsule())
                                
                                
                                
                                
                            }
                            
                            
                            
                        })
                        .padding(.leading)
                        .padding(.top, 6)
                        
                        
                        Spacer()
                        Button {
                            
                            
                            
                            
                            var newInboxItem = ReceivedResult()
                            
                            newInboxItem.profilePictureUrl = user.userData.profilePictureUrl
                            newInboxItem.userId = user.userData.userId
                            newInboxItem.mediaType = "image"
                            newInboxItem.signedPostUrl = ""
                            newInboxItem.notificationType = "sent"
                            newInboxItem.createdAt = NSDate().timeIntervalSince1970
                            newInboxItem.opened = false
                            newInboxItem.totalDelivered = user.userData.subscribers

                            
                            
                            
                            inbox.receivedResults.insert(newInboxItem, at: 0)
                            
                            
                            
                            
                            Task {
                                
                                
                                
                                currentTab = 0
                                
                                if camera.showMoviePreview {
                                    try await camera.saveVideo()
                                } else {
                                    try await camera.savePic()
                                    
                                }
                                
                            }
                            
                            
                            
                        } label: {
                            
                            
                            Image(systemName: "arrow.up.circle.fill")
                                .renderingMode(.original) // <1>
                                .foregroundColor(.blue)
                                .font(.system(size: 42, weight: .bold))
                                .padding(.horizontal,20)
                                .clipShape(Capsule())
                            
                            
                        }
                        .padding(.trailing)
                        .padding(.top, 6)
                        
                    }
                    .padding(.bottom, geo.safeAreaInsets.bottom + 60)
                    .background(.black)
                    
                }
                
                
                
            }
        }
    }
    
    
    
}






struct PlayerView: UIViewRepresentable {
    
    @Binding var player: AVPlayer
    
    func makeUIView(context: Context) -> PlayerUIView {
        return PlayerUIView(player: player)
    }
    
    func updateUIView(_ uiView: PlayerUIView, context: UIViewRepresentableContext<PlayerView>) {
        uiView.playerLayer.player = player
        uiView.playerLayer.videoGravity = .resizeAspectFill
        
        //Add player observer.
        uiView.setObserver()
    }
    
    
}

class PlayerUIView: UIView {
    
    // MARK: Class Property
    
    let playerLayer = AVPlayerLayer()
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(player: AVPlayer) {
        super.init(frame: .zero)
        self.playerSetup(player: player)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Life-Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
    
    // MARK: Class Methods
    
    private func playerSetup(player: AVPlayer) {
        playerLayer.player = player
        player.actionAtItemEnd = .none
        layer.addSublayer(playerLayer)
        
        self.setObserver()
    }
    
    func setObserver() {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd(notification:)),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: playerLayer.player?.currentItem)
        
        
        
    }
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: .zero, completionHandler: nil)
            self.playerLayer.player?.play()
        }
    }
}




struct ProgressBar: View {
    @Binding var progress: Float
    
    var body: some View {
        ZStack {
            
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 10.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(.pink)
                .rotationEffect(Angle(degrees: 275.0))
                .animation(.linear)
            
            
        }
    }
}



struct Grid: View {
    
    
    
    
    var body: some View {
        
        GeometryReader { geo in
            
            
        
        ZStack {
            
            HStack {
                Spacer()

                VStack {
                    
                }
                .frame(minWidth: 1, maxWidth: 1, minHeight: 100, maxHeight: .infinity, alignment: .center)
                .background(Color.white.opacity(0.3))

                Spacer()

                VStack {
                    
                }
                .frame(minWidth: 1, maxWidth: 1, minHeight: 100, maxHeight: .infinity, alignment: .center)
                .background(Color.white.opacity(0.3))
                Spacer()


            }
            
            
            VStack {
                Spacer()

               
                

                HStack {
                    
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 1, maxHeight: 1, alignment: .center)
                .background(Color.white.opacity(0.3))
                Spacer()
                HStack {
                    
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 1, maxHeight: 1, alignment: .center)
                .background(Color.white.opacity(0.3))
                Spacer()

            }
           
            
            
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        .padding(.bottom, geo.safeAreaInsets.bottom + 55)
            
        }
    }
}


