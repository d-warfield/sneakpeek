//
//  LandingViewItem.swift
//  sneakpeek (iOS)
//
//  Created by Dennis Warfield on 4/22/22.
//

import SwiftUI

struct LandingViewItem: View {
    
    var header: String
    var subheader: String
    var image: String



    
    var body: some View {
        
        GeometryReader { geo in
            
            
            VStack(alignment: .center) {
                Spacer()

                
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geo.size.width * 1, height: geo.size.height * 0.66, alignment: .center)
                    
                
                
                Text(header)
                    .font(.system(size: 30, weight: .bold))
                    .padding()
                    .multilineTextAlignment(.center)

                Text(subheader)
                    .foregroundColor(.secondary)
                    .padding(.top, -15)
                    .padding(.horizontal, 40)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 40)

                
            }
        }
            
        
    }
}


