//
//  InboxSentGroupItemPicture.swift
//  sneakpeek
//
//  Created by Dennis Warfield on 5/13/22.
//

import SwiftUI

struct InboxSentGroupItemPicture: View {
    
    @EnvironmentObject var inbox: InboxServiceModel
    
    
    @State var shuffledSubscribersProfilePictureUrls: [SubscriberProfilePictureUrl]?
    @State var isShuffling = true

  

    
    
    var body: some View {
        
        
        if self.isShuffling {
            
            ZStack(alignment: .center) {
                
            }
            .onAppear {
                self.isShuffling = true
                self.shuffledSubscribersProfilePictureUrls = inbox.subscribersProfilePictureUrls.shuffled()
                self.isShuffling = false
            }
            
            .aspectRatio(contentMode: .fill)
            .frame(width: 45, height: 45)
            .background(.thinMaterial)
            .clipShape(Circle())
            .padding([.trailing], 8)

            
        } else {
            ZStack(alignment: .center) {
                
                
                switch inbox.subscribersProfilePictureUrls.count {
                    
                        
                    
                case 0:
                    
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
                    
                    
                  
                case 1:
                    
                    MiniAsyncImage(size: 45, position: [22.5, 22.5], subscriberProfilePicture: shuffledSubscribersProfilePictureUrls![0])
                    
                case 2:
                    
                    MiniAsyncImage(size: 22, position: [16.2, 17.5], subscriberProfilePicture: shuffledSubscribersProfilePictureUrls![0])
                    MiniAsyncImage(size: 14, position: [30.6, 31], subscriberProfilePicture: shuffledSubscribersProfilePictureUrls![1])
                    
                case 3:
                    MiniAsyncImage(size: 20, position: [17.2, 14.5], subscriberProfilePicture: shuffledSubscribersProfilePictureUrls![0])
                    MiniAsyncImage(size: 14, position: [34.5, 24], subscriberProfilePicture: shuffledSubscribersProfilePictureUrls![1])
                    MiniAsyncImage(size: 12, position: [22.5, 35], subscriberProfilePicture: shuffledSubscribersProfilePictureUrls![2])
                    
                case 4...:
                    MiniAsyncImage(size: 20, position: [15.2, 16.5], subscriberProfilePicture: shuffledSubscribersProfilePictureUrls![0])
                    MiniAsyncImage(size: 16, position: [32.5, 28], subscriberProfilePicture: shuffledSubscribersProfilePictureUrls![1])
                    MiniAsyncImage(size: 10, position: [32.5, 13], subscriberProfilePicture: shuffledSubscribersProfilePictureUrls![2])
                    MiniAsyncImage(size: 10, position: [17, 34], subscriberProfilePicture: shuffledSubscribersProfilePictureUrls![3])
                    
                    
                    
                    
                    
                    
                    
                default:
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 45, height: 45)
                        .clipShape(Circle())
                        .foregroundColor(.secondary)
                }
                
                
                
            }
            
          
            
            .aspectRatio(contentMode: .fill)
            .frame(width: 45, height: 45)
            .background(.thinMaterial)
            .clipShape(Circle())
            .padding([.trailing], 8)
            
        }
        
       
        
    }
}






struct MiniAsyncImage: View {
    
    var size: CGFloat
    var position: [CGFloat]
    var subscriberProfilePicture: SubscriberProfilePictureUrl?
    
    
    
    var body: some View {
        
        
        
        
        AsyncImage(url: URL(string:  (subscriberProfilePicture?.profilePictureUrl!)!)) { image in
            image.resizable()
            
        } placeholder: {
            
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size, height: size)
                .clipShape(Circle())
                .foregroundColor(.secondary)
            
        }
        
        .aspectRatio(contentMode: .fill)
        .frame(width: size, height: size)
        .clipShape(Circle())
        .position(x: position[0], y: position[1])
        
        
        
        
        
    }
    
}




