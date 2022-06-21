//
//  LandingView.swift
//  sneakpeek (iOS)
//
//  Created by Dennis Warfield on 4/9/22.
//

import SwiftUI

struct LandingView2: View {
    
    @State var isNavigationBarHidden: Bool = true
    @State var currentTab: Int = 0
    
    
    
    
    var body: some View {
        
        
        
        VStack {
            Spacer()
            
            
            LandingViewItem(header: "Receive pics and videos", subheader: "Get pics and videos directly in your inbox", image: "inbox")
                .tag(1)
            
                .navigationBarTitle("Back")
                .navigationBarHidden(self.isNavigationBarHidden)
                .onAppear {
                    self.isNavigationBarHidden = true
                }
            
            Spacer()
            
            HStack {
                
                
                NavigationLink(destination: PhoneNumberView()) {
                    
                    Text("Continue")
                    
                }
                .buttonStyle(DefaultButtonStyle())
                
                
            }
            
        }
        
        
        
    }
    
    
}


struct LandingView2_Previews: PreviewProvider {
    static var previews: some View {
        LandingView()
    }
}


