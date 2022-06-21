//
//  InboxItemTagReceived.swift
//  sneakpeek (iOS)
//
//  Created by Dennis Warfield on 4/9/22.
//

import SwiftUI

struct InboxItemTagOpened: View {
    var body: some View {
        HStack(spacing: 4) {
//            RoundedRectangle()
//                .fill(Color.clear)
//                .frame(width:15, height: 15, alignment: .center)
//                .border(.secondary, width: 1)
//                .cornerRadius(3, antialiased: true)
//                .clipped()
            
           Image(systemName: "circle")
                .font(.system(size: 14, weight: .light, design: .default))
                .foregroundColor(.secondary)
            

            Text("Opened")
                .font(.system(size: 13))
                .fontWeight(.regular)
                .foregroundColor(.secondary)
                
        }
    }
}

struct InboxItemTagOpened_Previews: PreviewProvider {
    static var previews: some View {
        InboxItemTagOpened()
    }
}
