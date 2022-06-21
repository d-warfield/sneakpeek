//
//  BankListView.swift
//  sneakpeek (iOS)
//
//  Created by Dennis Warfield on 4/14/22.
//

import SwiftUI

struct BankListView: View {
    var body: some View {
        
        VStack {
            
            List {
                
                
                NavigationLink(destination: PaypalView()) {
//                    Label("Paypal", systemImage: "folder")HStack {
                    Image("paypal-min")
                        .resizable()
                        .frame(width: 20, height: 20, alignment: .center)
                        .font(.system(size: 22))
                        .foregroundColor(.purple)
                    
                    
                    Text("Paypal")
                        .font(.body)
                    
                    
                
                    
                }
//                NavigationLink(destination: VenmoView()) {
//                    Image("venmo-min")
//                        .resizable()
//                        .frame(width: 18, height: 18, alignment: .center)
//                        .font(.system(size: 22))
//                        .foregroundColor(.purple)
//                    
//                    
//                    Text("Venmo")
//                        .font(.body)
//                    
//                    
//                }
            }
            .listStyle(.automatic)
        }
        .navigationBarTitle("Bank Options", displayMode: .inline)

    }
}

struct BankListView_Previews: PreviewProvider {
    static var previews: some View {
        BankListView()
    }
}
