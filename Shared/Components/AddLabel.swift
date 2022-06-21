//
//  AddLabel.swift
//  sneakpeek (iOS)
//
//  Created by Dennis Warfield on 4/27/22.
//

import SwiftUI

struct AddLabel: View {
    
    
    @State private var bouncing = true


    
    var body: some View {
        VStack(alignment: .leading) {
            Triangle()
                .fill(.blue)
                .frame(width:34, height: 21)
                .padding(.bottom, -20)
                .padding(.leading, 10)
                .zIndex(1)

            VStack {
                
                Text("Subscribe")
                    .foregroundColor(.white)
                    .font(.system(size: 12, weight: .bold))
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .background(.blue)
            .cornerRadius(10)
            .zIndex(0)
            
            
            
        }

        
        .frame(maxHeight: 50, alignment: bouncing ? .bottom : .top)
                   .animation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true))
                   .onAppear {
                       self.bouncing.toggle()
                   }
                   

        
        
    }
    
}

struct AddLabel_Previews: PreviewProvider {
    static var previews: some View {
        AddLabel()
    }
}
