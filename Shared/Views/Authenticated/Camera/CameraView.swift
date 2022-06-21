//
//  CameraView.swift
//  sneakpeek (iOS)
//
//  Created by Dennis Warfield on 4/9/22.
//

import SwiftUI

struct CameraView: View {
    @EnvironmentObject var user: UserFetchServiceResultModel
    @EnvironmentObject var camera: CameraModel

    @State var capturedImage: UIImage? = nil
    @State private var isCustomCameraViewPresented = false
    @State private var isLoading = false
    @Binding var currentTab: Int

    

    
    var body: some View {
        ZStack {
            
            if user.userData.accountType == nil || user.userData.accountType! == "creator" {
                
                
                
                CustomCameraView(currentTab: $currentTab)
                    .padding(.top, -100)
                
            } else {
                GeometryReader { geo in
                    
                    VStack {
                        
                        
                        VStack {
                            
                            Text("Earn by sending photos; and videos")
                                .font(.system(size: 28, weight: .bold, design: .default))
                                .multilineTextAlignment(.center)
                            GeometryReader { geo in
                                
                                Image("earn-min")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geo.size.width * 1, height: geo.size.height * 1)
                                
                            }
                            
                            
                            
                            
                            VStack(alignment:.leading, spacing: 20) {
                               
                                
                                HStack(alignment: .top) {
                                    Image(systemName: "dollarsign.circle.fill")
                                        .font(.system(size: 30))
                                        .foregroundColor(.secondary)
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text("Charge subscribers to view")
                                            .font(.headline)
                                        Text("Charge a monthly fee for access to exclusive moments")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                            .fixedSize(horizontal: false, vertical: true)
                                        
                                        
                                        
                                    }
                                }
                                
                                HStack(alignment: .top) {
                                    Image(systemName: "eye.circle.fill")
                                        .font(.system(size: 30))
                                        .foregroundColor(.secondary)
                                    
                                    
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text("View one time only")
                                            .font(.headline)
                                        
                                        
                                        Text("Each moment can only be viewed once and then disappears forever")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                            .fixedSize(horizontal: false, vertical: true)
                                        
                                        
                                    }
                                }
                            }
                            .padding()
                            
                        }
                        
                        Button {
                            
                            camera.Check()
                            self.isLoading = true
                            
                            
                            Task {
                                try await user.updateAccountType(accountType: "creator")
                            }
                            self.isLoading = false
                            
                        } label:  {
                            
                            if self.isLoading {
                                Text("Loading...")
                            } else {
                                Text("Open Creator Account")
                            }
                            
                            
                            
                        }
                        
                        .disabled(isLoading)
                        .padding([.bottom], 52  )
                        .buttonStyle(DefaultButtonStyle())
                        
                    }
                    
                    
                }
            }
            
            
            
            
            
            
            
            
            
        }
        //        .ignoresSafeArea()
        
        
        .edgesIgnoringSafeArea(.top)
        
        
        
        .zIndex(1)
        .navigationBarTitleDisplayMode(.inline)
        //        .navigationBarTitle("")
        
        
        
    }
}



extension UIApplication {
    /**
     Get status bar view
     */
    var statusBarUIView: UIView? {
        let tag = 13101996
        if let statusBar = self.windows.first?.viewWithTag(tag) {
            self.windows.first?.bringSubviewToFront(statusBar)
            return statusBar
        } else {
            let statusBarView = UIView(frame: UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame ?? .zero)
            statusBarView.tag = tag
            
            self.windows.first?.addSubview(statusBarView)
            return statusBarView
        }
    }
}
