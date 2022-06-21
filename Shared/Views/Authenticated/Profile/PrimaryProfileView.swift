//
//  ProfileView.swift
//  sneakpeek (iOS)
//
//  Created by Dennis Warfield on 4/9/22.
//

import SwiftUI
import UIKit

struct PrimaryProfileView: View {
    
    @EnvironmentObject var user: UserFetchServiceResultModel
    @EnvironmentObject var bank: BankingServiceModel
    
    
    @ScaledMetric var size: CGFloat = 1
    @State private var showAlert = false
    
    func shareApp() {
        let sms = "sms:&body=Hey! Check out this app! www.sneakpeek.to"
        let strURL = sms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        UIApplication.shared.open(URL(string: strURL)!, options: [:], completionHandler: nil)
    }
    
    
    
    
    func actionSheet() {
        guard let data = URL(string: "sneakpeek.to/@\(user.userData.username!)") else { return }
        let av = UIActivityViewController(activityItems: [data], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }
    
    
    
    var body: some View {
        
        
        ZStack {
            
            
            
            if user.userData.subscriptions == 0 || user.userData.accountType != "creator" {
                
                
                HStack {
                    NavigationLink(destination: SearchView()) {
                        
                        
                    }
                    
                    
                }
                .position(x: 54, y: 25)
                .zIndex(1)
                
            }
            
            
            
            //            AddLabel()
            //                .position(x: 100, y: 0)
            //                .zIndex(1)
            
            
            
            
            
            VStack(spacing: 0) {
                
                
                
                ProfileHeader(primaryUserData: user.userData, primaryUserIsActive: true)
                
                
                
                
                
                HStack {
                    NavigationLink(destination: EditProfileView()) {
                        HStack {
                            Text("Edit Profile")
                                .frame(minWidth: 150, maxWidth: 150, minHeight: 46, maxHeight: 46)
                                .font(.subheadline.bold())
                                .foregroundColor(.black)
                            
                            
                        }
                        .background(.regularMaterial)
                        .cornerRadius(8)
                        
                        
                    }
                    
                    
                    if user.userData.accountType == "creator" {
                        NavigationLink(destination: CreatorToolsView()) {
                            
                            
                            ZStack {
                                
                                
                                Image(systemName: "paintbrush.fill")

                            }
                            .frame(minWidth: 46, maxWidth: 46, minHeight: 46, maxHeight: 46)

                            .zIndex(0)
                            .background(.regularMaterial)
                            .cornerRadius(8)

                        }
                        
                    }
                    
                    ZStack {
                        
                        
                        Button {
                            
                            let string =  "sneakpeek.to/@\(user.userData.username!)"
                            UIPasteboard.general.string = string
                            showAlert = true
                            
                            
                        } label: {
                            Image(systemName: "square.and.arrow.up.on.square.fill")
                            
                            
                                .frame(minWidth: 46, maxWidth: 46, minHeight: 46, maxHeight: 46)
                                .foregroundColor(.black)
                        }
                        .alert("Profile link copied", isPresented: $showAlert) {
                            
                            Button("OK", role: .cancel) { }
                        }
                        
                       
                        
                       
                        
                    }
                    
                    .zIndex(0)
                    .background(.regularMaterial)
                    .cornerRadius(8)
                    
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 8)
//
//                            .stroke(Color.black.opacity(0.15), lineWidth: 1)
//                            .zIndex(0)
//
//
//                    )
                }
                .padding(.top, 10)
                
               
                
                
                
                
                
                
                Spacer()
            }
            
            
            
            .toolbar {
                ToolbarItem(placement: .principal) {
                    
                    if (user.userData.pronoun!.count > 0) {
                        VStack {
                            Text("\(user.userData.displayName ?? "")")
                                .font(.headline)
                            Text("\(user.userData.pronoun ?? "")")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    } else {
                        Text("\(user.userData.displayName ?? "")")
                            .font(.headline)
                        
                    }
                    
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    
                    Button {
                        
                        shareApp()

                        
                        
                        
                    } label: {
                        
                        
                      
                        Image(systemName: "paperplane")

                        
                    }
                
                    
                    
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    
                    NavigationLink(destination: SearchView()) {
                        Image(systemName: "magnifyingglass")
                        
                        
                        
                        
                        
                    }
                    
                }
            }
            
            
            
        }
        .onAppear {
//            TabBarView().setCurrenTabToInbox()
        }
        .task {
            try! await bank.fetchBanking()
        }
        .edgesIgnoringSafeArea([.bottom])
        
        
    }
    
}



struct PrimaryProfileView_Previews: PreviewProvider {
    static var previews: some View {
        PrimaryProfileView()
            .environmentObject(UserFetchServiceResultModel())
    }
}
