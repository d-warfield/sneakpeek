//
//  InboxItemTagReceived.swift
//  sneakpeek (iOS)
//
//  Created by Dennis Warfield on 4/9/22.
//

import SwiftUI

struct InboxItemTagSent: View {
    
    @EnvironmentObject var user: UserFetchServiceResultModel
    var item: ReceivedResult

    
    var body: some View {
        HStack(spacing: 4) {

            
            Image(systemName: item.createdAt! < item.createdAt! + 1  ?  "location.north.fill" : "location.north")
                .resizable()
                .frame(width: 14, height: 14)
                .font(.system(size: 14, weight: .light, design: .default))
                .foregroundColor(item.createdAt! < item.createdAt! + 1 ? .blue : .secondary)
                .rotationEffect(.degrees(90))
            

            Text(item.createdAt! < item.createdAt! + 1 ? "\(item.totalDelivered!   ?? 1) Delivered" : "Opened")
                .font(.system(size: 13))
                .fontWeight(item.createdAt! < item.createdAt! + 1 ? .bold : .regular)
                .foregroundColor(item.createdAt! < item.createdAt! + 1 ?  .blue : .secondary)
                .padding(.leading, 2)
                
        }
    }
}


