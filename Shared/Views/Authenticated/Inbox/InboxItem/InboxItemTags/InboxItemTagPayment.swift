//
//  InboxItemTagPayment.swift
//  sneakpeek (iOS)
//
//  Created by Dennis Warfield on 4/9/22.
//

import SwiftUI

struct InboxItemTagPayment: View {
    
    var amount: Double?
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "dollarsign.circle.fill")
                 .font(.system(size: 14, weight: .regular))
                 .foregroundColor(.blue)
                
            Text("Paid you $\(amount!, specifier: "%.2f")")
            
                .font(.system(size: 13))
                .fontWeight(.bold)
                .foregroundColor(.blue)
        }
    }
}

struct InboxItemTagPayment_Previews: PreviewProvider {
    static var previews: some View {
        InboxItemTagPayment()
    }
}
