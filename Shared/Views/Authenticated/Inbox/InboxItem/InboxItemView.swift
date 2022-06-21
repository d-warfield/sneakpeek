//
//  InboxItemView.swift
//  sneakpeek (iOS)
//
//  Created by Dennis Warfield on 4/9/22.
//

import SwiftUI
import AVKit


struct InboxItemView: View {
    @EnvironmentObject var inbox: InboxServiceModel
    @EnvironmentObject var user: UserFetchServiceResultModel

    var item: ReceivedResult
    var index: Int
    
    @State private var isPresented = false
    @State var opened = false
    @State var timestampPrefix: String = ""
    @State var timeDifference: Int = 0
    @State var thumbnail: Data?
    
    var body: some View {
        
        
        
        Button {
            if inbox.receivedResults[index].notificationType == "received" {
                
                if !self.opened {
                    
                    
                    self.isPresented.toggle()
                    if !self.opened {
                        
                        self.opened = true
                        inbox.receivedResults[index].opened = true
                        
                        
                        Task {
                            try await inbox.updateOpened(postId: item.postId!, postOwner: item.userId!)
                            try await inbox.updateTotalViews(userId: item.userId!, postId: item.postId!)
                            
                        }
                    }
                }
            } else {
                if item.signedPostUrl != "" {
                 
                    self.isPresented.toggle()
                } else {
                    print("Still uploading")
                }
                

            }
        } label: {
            
            HStack {
                
                
                
                if item.notificationType == "sent" {
                    
                    
                    
                    InboxSentGroupItemPicture()
                    
  
                }
                
                
                if item.notificationType == "received" {
                    
                    
                    AsyncImage(url: URL(string:  item.profilePictureUrl!)) { image in
                        image.resizable()
                        
                        
                    } placeholder: {
                        
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 45, height: 45)
                            .clipShape(Circle())
                            .foregroundColor(.secondary)
                    }
                    
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 45, height: 45)
                    .clipShape(Circle())
                    .padding([.trailing], 8)
                    
                }
                
                
                
                
                
                //
                //
                
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 6 ) {
                            Text("\(item.notificationType == "sent" ? user.userData.subscribers! > 0 ? "Subscribers" : "Sneakpeek" : item.displayName!.capitalized)")
                                .font(.system(.headline, design: .default))
                            
                                .padding(0)
                            
                            
                            switch item.notificationType! {
                            case "received":
                                if opened {
                                    InboxItemTagOpened()
                                } else {
                                    InboxItemTagReceived()
                                    
                                }
                                
                            case "newSubscriber":
                                
                                InboxItemTagPayment(amount: item.amount)
                                
                            case "sent":
                                InboxItemTagSent(item: item)
                                
                            default:
                                Text("")
                            }
                            
                            
                        }
                        
                        Spacer()
                        
                        VStack {
                            Text("\(getTimeSinceTimestamp(timestamp: item.createdAt!))")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        
                    }
                    Rectangle()
                        .fill(Color.secondary.opacity(0.3))
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0.5, maxHeight: 0.5)
                }
                
                
                
                
                
            }
            .onAppear {
                
                if item.mediaType == "video" {
                    
                    
                    imageFromVideo(url: URL(string: item.signedPostUrl!)!, at: 0) { image in
                        
                        let data = image?.pngData()
                        self.thumbnail = data
                        
                    }
                }
            }
            
            
            
            .fullScreenCover(isPresented: $isPresented, content: {FullScreenModalView(item: item)} )
            
            
            
            
            .onAppear {
                
                if item.opened != nil {
                    self.opened = item.opened!
                    
                }
                getTimeSinceTimestamp(timestamp: item.createdAt!)
                
            }
        }
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
        
    }
    
    public func imageFromVideo(url: URL, at time: TimeInterval, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let asset = AVURLAsset(url: url)
            
            let assetIG = AVAssetImageGenerator(asset: asset)
            assetIG.appliesPreferredTrackTransform = true
            assetIG.apertureMode = AVAssetImageGenerator.ApertureMode.encodedPixels
            
            let cmTime = CMTime(seconds: time, preferredTimescale: 60)
            let thumbnailImageRef: CGImage
            do {
                thumbnailImageRef = try assetIG.copyCGImage(at: cmTime, actualTime: nil)
            } catch let error {
                print("Error: \(error)")
                return completion(nil)
            }
            
            DispatchQueue.main.async {
                completion(UIImage(cgImage: thumbnailImageRef))
            }
        }
    }
    
    func getTimeSinceTimestamp(timestamp: Double) -> String {
        // disabled entire view animations
        //            UIView.setAnimationsEnabled(false)
        
        
        
        let unixTimestamp = item.createdAt!
        let date = Date(timeIntervalSince1970: unixTimestamp)
        let interval = Date() - date
        if (interval.month! >= 1) {
        
            return String("\(interval.month!)mon")

        } else if (interval.day! >= 1) {
          
            return String("\(interval.day!)d")

        } else if (interval.hour! <= 24 && interval.hour! >= 1) {
         
            return String("\(interval.hour!)h")

        } else if (interval.minute! <= 60 && interval.minute! >= 1) {
           
            return String("\(interval.minute!)m")

        } else if (interval.second! <= 60 && interval.second! >= 0) {

            
            return String("now")
        }
        
        return "Hello"
    }
    
    
    
}




struct FullScreenModalView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var camera: CameraModel
    @EnvironmentObject var user: UserFetchServiceResultModel
    @EnvironmentObject var inbox: InboxServiceModel
    
    
    
    var item: ReceivedResult
    @State private var player = AVPlayer(url: URL(string: "https://media.w3.org/2010/05/sintel/trailer.mp4")!)
    @State private var isBuffering = true
    @State private var isPresented = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var progressValue: Float = 0.0
    @State var isLoading = true
    
    
    
    
    
    
    
    
    var body: some View {
        
        
        
        
        GeometryReader { geo in
            
            
            
            ZStack {
                
                
                
                if item.mediaType! == "image" {
                    
                    
                    
                    //                    AsyncImage(url: URL(string: item.signedPostUrl!)) { image in
                    //                        image.resizable()
                    //
                    //
                    //
                    //                    } placeholder: {
                    //
                    //                        ProgressView()
                    //                    }
                    //
                    //                    .aspectRatio(contentMode: .fill)
                    //                    .frame(minWidth: 0, maxWidth: geo.size.height , minHeight: 0, maxHeight: geo.size.width * 1.25, alignment: .center)
                    //                    .rotationEffect(.degrees(90))
                    //
                    
                    AsyncImage(url: URL(string: item.signedPostUrl!)) { phase in
                        if let image = phase.image {
                            
                            image.resizable()
                            
                            //
                            
                        } else if phase.error != nil {
                            Text("Can't load media")
                        } else {
                            
                            
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                                .onDisappear {
                                    
                                    
                                    self.isLoading = false
                                    
                                    
                                }
                            
                            
                        }
                    }
                    .aspectRatio(contentMode: .fill)
                    .frame(minWidth: 0, maxWidth: geo.size.height , minHeight: 0, maxHeight: geo.size.width * 1.25, alignment: .center)
                    .rotationEffect(.degrees(90))
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))

                    
                    
                    
                    
                }
                //
                
                
                if item.mediaType! == "video" {
                    
                    if self.isBuffering {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                            .onDisappear {
                                
                                
                                self.isLoading = false
                                
                                
                            }
                        
                    } else {
                        PlayerView(player: $player)
                            .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))

                        
                    }
                    
                    
                    
                    
                    //                        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                    
                    
                }
                
                
                
                
                
                if item.userId == user.userData.userId && !self.isLoading  {
                    
                    
                    
                    
                    VStack(alignment: .center) {
                        Spacer()
                        
                        HStack {
                            
                            
                            Button {
                                self.isPresented = true
                                
                            } label: {
                                
                                HStack {
                                    
                                    
                                    Text("Analytics")
                                        .font(.subheadline).bold()
                                        .foregroundColor(.black)
                                    
                                    Image(systemName: "chart.bar.fill")
                                        .foregroundColor(.black)
                                }
                                .padding(.vertical, 12)
                                .padding(.horizontal, 22)
                                .background(.white)
                                .cornerRadius(1000)
                                
                            }
                            
                            
                            
                            
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                        .padding(.bottom, geo.safeAreaInsets.bottom)
                        .padding(.top, 8)
                        .background(.black)
                        
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                    .background(.clear)

                }
                
                
            }
            .fullScreenCover(isPresented: $isPresented, content: {AnalyticsFullScreenModalView(item: item)
                    .onAppear {
                        
                        player.pause()
                    }
                    .onDisappear {
                        
                        player.play()
                    }
            } )
            
            .onAppear {
                
                
                
                    
                
                
                player = AVPlayer(url: URL(string: item.signedPostUrl!)!)
                player.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 600), queue: DispatchQueue.main, using: { time in
                    
                    if player.currentItem?.status == AVPlayerItem.Status.readyToPlay {
                        
                        if let isPlaybackLikelyToKeepUp = player.currentItem?.isPlaybackLikelyToKeepUp {
                            
                            
                            self.isBuffering = false
                            
                            
                        }
                    }
                })
                
                player.play()
                
            }
            .onDisappear {
                player.seek(to: .zero)
                player.pause()
                
                self.isPresented.toggle()
                
                if user.userData.userId != item.userId {
                    
                
                Task {
                
                    try await inbox.updateTotalTimeViewed(userId: item.userId!, postId: item.postId!, totalTimeViewed: self.progressValue)
                }
                }
                
            }
            .onReceive(timer) { _ in
                if !self.isLoading {
                    progressValue += 1
                    
                }
                
            }
            
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
            .ignoresSafeArea(.all)
            
            
            .gesture(DragGesture(minimumDistance: 20, coordinateSpace: .global)
                .onEnded { value in
                    let horizontalAmount = value.translation.width as CGFloat
                    let verticalAmount = value.translation.height as CGFloat
                    
                    if abs(horizontalAmount) > abs(verticalAmount) {
                        presentationMode.wrappedValue.dismiss()
                        
                    } else {
                        presentationMode.wrappedValue.dismiss()
                    }
                })
            
        }
        .background(.black)
    }
}





struct AnalyticsFullScreenModalView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var inbox: InboxServiceModel
    var item: ReceivedResult
    @State private var player = AVPlayer(url: URL(string: "https://media.w3.org/2010/05/sintel/trailer.mp4")!)
    @State private var isBuffering = true
    @State private var isPresented = false
    @State private var isLoading = true
    @State var timestampPrefix: String = ""
    @State var timeDifference: Int = 0
    weak var timer: Timer?
    
    
    
    
    
    
    var body: some View {
        
        GeometryReader { geo in
            
            if self.isLoading {
                ProgressView()
            } else {
                VStack {
                    
                    
                    
                    HStack {
                        
                    }
                    .frame(minWidth: 50 , maxWidth: 50, minHeight: 6, maxHeight: 6, alignment: .center)
                    .background(.secondary)
                    .cornerRadius(100)
                    .padding(.bottom, 50)
                    
                    
                    VStack(alignment: .leading) {
                        
                        HStack {
                            Text("Views")
                            Spacer()
                            Text("\(inbox.postAnalytics.totalViews ?? 0)")
                        }
                        .padding(.bottom, 1)
                        Text("The total number of views")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        
                    }
                    .padding()
                    
                    
                    
                    
                    
                    VStack(alignment: .leading) {
                        
                        HStack {
                            Text("Total Recipients")
                            Spacer()
                            Text("\(inbox.postAnalytics.totalRecipients ?? 0)")
                        }
                        .padding(.bottom, 1)
                        
                        Text("The total number of recipients who received the post")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                    }
                    .padding()
                    
                    VStack(alignment: .leading) {
                        
                        HStack {
                            Text("Total Time Viewed")
                            Spacer()
                            Text("\(inbox.postAnalytics.totalTimeViewed ?? 0)s")
                        }
                        .padding(.bottom, 1)
                        
                        Text("The total amount of time in seconds subscribers spent viewing this post")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                    }
                    .padding()
                    
                    
                    VStack(alignment: .leading) {
                        
                        HStack {
                            Text("Sent")
                            Spacer()
                            Text("\(timeDifference)\(timestampPrefix)")
                        }
                        .padding(.bottom, 1)
                        
                        Text("Time since post was sent to subscribers")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                    }
                    .padding()
                    
                    
                    
                    
                    Spacer()
                }
                .padding()
                
                
                
                
                
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                //            .ignoresSafeArea(.all)
                .background(.white)
                
                
                .gesture(DragGesture(minimumDistance: 20, coordinateSpace: .global)
                    .onEnded { value in
                        let horizontalAmount = value.translation.width as CGFloat
                        let verticalAmount = value.translation.height as CGFloat
                        
                        if abs(horizontalAmount) > abs(verticalAmount) {
                            presentationMode.wrappedValue.dismiss()
                            
                            
                        } else {
                            presentationMode.wrappedValue.dismiss()
                            
                            
                        }
                    })
            }
            
            
            
            
        }
        .background(.white)
        .onAppear {
            
            self.isLoading = true
            Task {
                try await inbox.fetchPostAnalytics(userId: item.userId!, postId: item.postId!)
            }
            self.isLoading = false
            
            let unixTimestamp = item.createdAt!
            let date = Date(timeIntervalSince1970: unixTimestamp)
            let interval = Date() - date
            if (interval.month! >= 1) {
                self.timeDifference = interval.month!
                if interval.month! == 1 {
                    self.timestampPrefix = "month"
                } else {
                    self.timestampPrefix = "months"
                }
            } else if (interval.day! >= 1) {
                self.timeDifference = interval.day!
                self.timestampPrefix = "d"
            } else if (interval.hour! <= 24 && interval.hour! >= 1) {
                self.timeDifference = interval.hour!
                self.timestampPrefix = "h"
            } else if (interval.minute! <= 60 && interval.minute! >= 1) {
                self.timeDifference = interval.minute!
                self.timestampPrefix = "m"
            } else if (interval.second! <= 60 && interval.second! >= 0) {
                self.timeDifference = interval.second!
                self.timestampPrefix = "s"
            }
        }
    }
}
