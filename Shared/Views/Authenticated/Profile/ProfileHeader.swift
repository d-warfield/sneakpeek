//
//  ProfileHeader.swift
//  sneakpeek (iOS)
//
//  Created by Dennis Warfield on 4/15/22.
//

import SwiftUI

struct ProfileHeader: View {
    
    @EnvironmentObject var isLoading: UserFetchServiceResultModel
    var primaryUserData: UserData?
    var secondaryUserData: SecondaryUserData?
    var primaryUserIsActive: Bool
    @State var timestampPrefix: String = ""
    @State var timeDifference: Int = 0
    
    
    
    var body: some View {
        
        VStack {
            VStack {
                AsyncImage(url: URL(string: primaryUserIsActive ? primaryUserData!.profilePictureUrl! : secondaryUserData!.profilePictureUrl! )) { image in
                    image.resizable()
                    
                } placeholder: {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .cornerRadius(1000)
                        .foregroundColor(.secondary)
                        .font(.headline)
                    
                }
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                
            }
            .padding([.top], 25)
            
            
            
            
            HStack {
             
                    Text("@\( primaryUserIsActive ? primaryUserData!.username! : secondaryUserData!.username!)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding([.top], 8)
                        .textCase(.lowercase)
               
                
            }
            
            
            
            
            HStack {
                VStack {
                    Image(systemName: "person.crop.circle.badge.clock.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 27, height: 27, alignment: .center)
                        .foregroundColor(.black)
                    
                    primaryUserIsActive ? Text("active now")
                        .font(.caption).bold()
                        .foregroundColor(.black) :

                    Text("\(timeDifference)\(timestampPrefix) ago")
                        .font(.caption).bold()
                        .foregroundColor(.black)
                    //                                .redacted(reason: user == nil ? .placeholder : [])
                    
                    
                    
                }
                .frame(width: 90, height: 62, alignment: .center)
                .background(.white)
                .cornerRadius(10)
                
              
                if primaryUserIsActive  && primaryUserData!.accountType == "creator" || !primaryUserIsActive && secondaryUserData!.accountType == "creator" {
                    
                
                VStack {
                    Image(systemName: "camera.shutter.button.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24, alignment: .center)
                        .foregroundColor(.black)
                    
                    
                    
                    
                    Text("\(primaryUserIsActive ? primaryUserData!.totalPostsSent! : secondaryUserData!.totalPostsSent!) sent")
                        .font(.caption).bold()
                        .foregroundColor(.black)

                    //                                .redacted(reason: user.userData == nil ? .placeholder : [])
                }
                .frame(width: 90, height: 62, alignment: .center)
                .background(.white)
                .cornerRadius(10)
                }
                
                
            }
            .padding([.top, .bottom ], 20)
            
            
            // conditionally render
            
            if primaryUserIsActive ? primaryUserData!.bio! != "" : secondaryUserData!.bio! != "" {
                HStack {
                    VStack {
                        Text("\(primaryUserIsActive ? primaryUserData!.bio! : secondaryUserData!.bio!)")
                        
                            .font(.subheadline)
                            .padding([.bottom],5)
                            .multilineTextAlignment(.center)
                        //                                    .redacted(reason: user.userData == nil ? .placeholder : [])
                        
                        
                    }.padding([.horizontal], 20)
                }.padding([.bottom],30)
            }
            
        }
        .zIndex(1)
        .onAppear ( perform: {
            if !primaryUserIsActive {
                let unixTimestamp = secondaryUserData?.lastActive!
                let date = Date(timeIntervalSince1970: unixTimestamp!)
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
                    
        )
        
    }
}
//
//struct ProfileHeader_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileHeader()
//    }
//}
