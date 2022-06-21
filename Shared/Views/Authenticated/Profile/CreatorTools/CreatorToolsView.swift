//
//  CreatorToolsView.swift
//  sneakpeek (iOS)
//
//  Created by Dennis Warfield on 4/20/22.
//

import SwiftUI

struct CreatorToolsView: View {
    @EnvironmentObject var user: UserFetchServiceResultModel
    @EnvironmentObject var banking: BankingServiceModel
    
    
    
    var body: some View {
        VStack {
            List {
                
                Section(footer: Text("Your balance, payments, and withdraws history")) {
                    
                    
                    NavigationLink(destination: WalletView()) {
                        HStack {
                            Text("Wallet")
                            Spacer()
                            Text("$\(banking.bankingData.balance!,specifier: "%.2f")")
                                .foregroundColor(.secondary)
                        }
                        
                    }
                }
                
                Section(footer: Text("The fee you charge your subscribers")) {
                    
                    
                    NavigationLink(destination: SubscriptionFeeView()) {
                        HStack {
                            Text("Subscription fee")
                            Spacer()
                            Text("$\(banking.bankingData.monthlySubFee!, specifier: "%.2f")")
                                .foregroundColor(.secondary)
                            
                        }
                        
                    }
                }
                
              
                
                
            }
        }
        .navigationBarTitle("Creator Tools", displayMode: .inline)
    }
}

struct CreatorToolsView_Previews: PreviewProvider {
    static var previews: some View {
        CreatorToolsView()
    }
}
