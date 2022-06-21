//
//  InboxItemView.swift
//  sneakpeek (iOS)
//
//  Created by Dennis Warfield on 4/9/22.
//

import SwiftUI
import AVKit


struct DummyInboxItemView: View {
    
    
    
    
    @State private var isPresented = false
    @Binding var dummyOpened: Bool
    @State var timestampPrefix: String = ""
    @State var timeDifference: Int = 0
    
    var body: some View {
        
        
        Button {
            self.isPresented.toggle()
            self.dummyOpened = true
        } label: {
            
            HStack {
                
                ZStack {
                    Image(systemName: "circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 45, height: 45)
                        .clipShape(Circle())
                        .foregroundColor(.black)
                    Image(systemName: "eyes.inverse")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 26, height: 26)
                        .foregroundColor(.white)
                }
                .padding([.trailing], 8)
                
                
                
                
                //                AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1651605095390-5e416e8fa863?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwyfHx8ZW58MHx8fHw%3D&auto=format&fit=crop&w=900&q=60")) { image in
                //                    image.resizable()
                //
                //
                //                } placeholder: {
                //
                //                    Image(systemName: "person.crop.circle.fill")
                //                        .resizable()
                //                        .aspectRatio(contentMode: .fill)
                //                        .frame(width: 45, height: 45)
                //                        .clipShape(Circle())
                //                        .foregroundColor(.secondary)
                //                }
                //
                //                .aspectRatio(contentMode: .fill)
                //                .frame(width: 45, height: 45)
                //                .clipShape(Circle())
                //                .padding([.trailing], 8)
                
                //
                //
                
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 6 ) {
                            Text("Sneakpeek")
                                .font(.system(.headline, design: .default))
                                .foregroundColor(.black)
                                .padding(0)
                            
                            
                            if !self.dummyOpened {
                                InboxItemTagReceived()
                                
                            } else {
                                InboxItemTagOpened()
                            }
                            
                            
                            
                            
                            
                        }
                        
                        Spacer()
                        
                        VStack {
                            Text("now")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        
                    }
                    Rectangle()
                        .fill(Color.secondary.opacity(0.3))
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0.5, maxHeight: 0.5)
                }
                
                
                
                
                
            }
            
            
            
            .fullScreenCover(isPresented: $isPresented, content: {DummyFullScreenModalView()} )
            
            
            
            
            
        }
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
        
    }
    
    
}


struct DummyFullScreenModalView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var camera: CameraModel
    
    //    var item: ReceivedResult
    @State private var player = AVPlayer(url: URL(string: "https://sneakpeek-misc-media.s3.us-east-2.amazonaws.com/intromovie.mp4")!)
    @State private var isBuffering = true
    
    
    
    
    
    var body: some View {
        
        GeometryReader { geo in
            
            
            
            ZStack {
                
                if self.isBuffering {
                    ProgressView()
                } else {
                    PlayerView(player: $player)
                    
                }
                
                
                
            }
            .frame(minWidth: geo.size.width * 1, minHeight: geo.size.height * 0.9, maxHeight: geo.size.height * 0.9)
            .onAppear {
                player = AVPlayer(url: URL(string: "https://sneakpeek-misc-media.s3.us-east-2.amazonaws.com/intromovie.mp4")!)
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
                
            }
            
            
            
      
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
        .background(.white)
        
    }
}
