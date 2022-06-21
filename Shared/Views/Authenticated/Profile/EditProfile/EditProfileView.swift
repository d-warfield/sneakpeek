//
//  EditProfileView.swift
//  sneakpeek (iOS)
//
//  Created by Dennis Warfield on 4/11/22.
//

import SwiftUI

struct EditProfileView: View {
    @EnvironmentObject var primaryUserData: UserFetchServiceResultModel
    @EnvironmentObject var auth: AuthViewModel
    @State private var showSheet = false
    @State private var avatarImageData: Data?
    @State private var showAlert = false
    @State private var notificationToggle = false
    
    
    
    
    
    
    var body: some View {
        
        
        
        return VStack {
            
            
            
            Button {
                
                self.showSheet = true
                
                
            } label: {
                
                
                VStack {
                    
                    VStack {
                        
                        
                        if primaryUserData.uploadProfilePictureIsLoading {
                            
                            ProgressView()
                            
                        } else {
                            AsyncImage(url: URL(string: primaryUserData.userData.profilePictureUrl! )) { image in
                                image.resizable()
                                
                            } placeholder: {
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(1000)
                                    .foregroundColor(.secondary)
                                    .font(.headline)
                                    .zIndex(1)
                                
                            }
                            .aspectRatio(contentMode: .fill)
                            
                        }
                    }
                    
                    .frame(width: 100, height: 100)
                    .background(Color.black.opacity(0.1))
                    .clipShape(Circle())
                    .padding([.top], 25)
                    .zIndex(0)
                    
                    
                    
                    
                    
                    Text("Change Photo")
                        .font(.subheadline)
                        .padding([.top], 10)
                    
                }
                
            }
            
            List {
                Section(header: Text("Profile Display").font(.subheadline).foregroundColor(.secondary)) {
                    NavigationLink(destination: DisplayNameView(), label: {Text("Display Name")
                    })
                    NavigationLink(destination: UsernameView(), label: {Text("Username")
                    })
                    NavigationLink(destination: BioView(), label: {Text("Bio")
                    })
                    NavigationLink(destination: PronounView(), label: {Text("Pronoun")
                    })
                    
                }
                
                Section {
                    NavigationLink(destination: AccountTypeView()) { Text("Account type")}
                }
                
                //                Section(footer: Text("Notications are disabled by default")) {
                //                    HStack {
                //
                //
                //
                //                        Toggle(isOn: $notificationToggle, label: {
                //                            Text("Notifications")
                //                        })
                //
                //
                //
                //                    }
                //                }
                
                Section {
                    Button {
                        
                        showAlert = true
                        
                        
                        //
                    } label: {
                        Text("Logout")
                            .foregroundColor(.pink)
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Logout"),
                            message: Text("Are you sure you want to logout?"),
                            primaryButton: .default(
                                Text("Cancel"),
                                action: {showAlert = false}
                            ),
                            secondaryButton: .destructive(
                                Text("Logout"),
                                action: {
                                    KeychainStorage.deleteCredentials()
                                    auth.checkAuthStatus()
                                }
                            )
                        )
                    }
                    
                    
                }
                
                
            }
            .listStyle(.automatic)
            .navigationBarTitle("Profile", displayMode: .inline)
            
            
        }
        .background(Color("listBackground"))
        .onChange(of: avatarImageData) { newValue in
            
            
            Task {
                
                let image = UIImage(data:avatarImageData!,scale: 1)
                let newImage = image!.scalePreservingAspectRatio(width: 600, height: 600)
                
                let compresseImageData =  newImage.jpegData(compressionQuality: 0.5)
                
                try await primaryUserData.updateProfilePictureUrl(avatarImageData: compresseImageData!)
            }
            
            
            
            
            
        }
        .sheet(isPresented: $showSheet, content: {
            PhotoPicker(avatarImageData: $avatarImageData)
            
        })
        
        
        
    }
}


