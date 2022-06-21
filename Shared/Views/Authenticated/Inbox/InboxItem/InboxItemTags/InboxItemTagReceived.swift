//
//  InboxItemTagReceived.swift
//  sneakpeek (iOS)
//
//  Created by Dennis Warfield on 4/9/22.
//

import SwiftUI

struct InboxItemTagReceived: View {
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "circle.fill")
                 .font(.system(size: 14, weight: .regular))
                 .foregroundColor(.pink)
                
            Text("Tap to view")
            
                .font(.system(size: 13))
                .fontWeight(.bold)
                .foregroundColor(.pink)
        }
    }
}

struct InboxItemTagReceived_Previews: PreviewProvider {
    static var previews: some View {
        InboxItemTagReceived()
    }
}
