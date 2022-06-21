//
//  LandingView.swift
//  sneakpeek (iOS)
//
//  Created by Dennis Warfield on 4/9/22.
//

import SwiftUI

struct LandingView: View {
    
    @State var isNavigationBarHidden: Bool = true
    @State var currentTab: Int = 0
    
    
    
    
    var body: some View {
        
        NavigationView {
            
            
            VStack {
                
                Spacer()

                
                LandingViewItem(header: "Subscribe for access", subheader: "Support your favorite creators and access their exclusive pics and videos", image: "subscribe")
                    .tag(1)
                
                    .navigationBarTitle("Back")
                    .navigationBarHidden(self.isNavigationBarHidden)
                    .onAppear {
                        self.isNavigationBarHidden = true
                    }
                
                Spacer()
                
                HStack {
                    
                    
                    NavigationLink(destination: LandingView2()) {
                        
                        Text("Continue")
                        
                    }
                    .buttonStyle(DefaultButtonStyle())
                    
                    
                }
                
            }
            
            
            
        }
        
    }
}


struct LandingView_Previews: PreviewProvider {
    static var previews: some View {
        LandingView()
    }
}


