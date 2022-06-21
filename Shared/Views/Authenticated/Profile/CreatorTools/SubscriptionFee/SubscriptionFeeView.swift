//
//  SubscriptionFeeView.swift
//  sneakpeek (iOS)
//
//  Created by Dennis Warfield on 4/14/22.
//

import SwiftUI

struct SubscriptionFeeView: View {
    @EnvironmentObject var banking: BankingServiceModel
    @Environment(\.dismiss) var dismiss
    @State var selectedMonthlySubFee = 1.99
    
    let subscriptions = [
        Subscription(price: 1.99),
        Subscription(price: 4.99),
        Subscription(price: 9.99),
        Subscription(price: 14.99)
        
    ]
    
    
    var body: some View {
        
        List {
            
            Section(footer: Text("Set a monthly fee that you'll charge to your subscribers for access to your content")) {
                
            
            ForEach(subscriptions) { subscription in
                
                
                Button {
                    self.selectedMonthlySubFee = subscription.price
                } label: {
                    HStack {
                        Text("$\(subscription.price, specifier: "%.2f")")
                            .foregroundColor(.primary)
                        
                        Text("monthly")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .padding(.top, 5)
                        Spacer()
                        if (subscription.price == selectedMonthlySubFee) {
                            Image(systemName: "checkmark")
                                
                            
                        }
                        
                        
                    }
                }
            }
                
            }
            
        }
        .listStyle(.automatic)

        .navigationBarTitle("Subscription Fee", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    Task {
                        dismiss()

                        try await banking.updateMonthlySubFee(monthlySubFee: selectedMonthlySubFee)
                    }
                    
                    
                } label: {
                    Text("Save")
                }
            }
            
        }
        .onAppear(perform:
                    {
            Task {
                self.selectedMonthlySubFee = banking.bankingData.monthlySubFee!
            }
        })
    }
}

struct SubscriptionFeeView_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionFeeView()
    }
}
