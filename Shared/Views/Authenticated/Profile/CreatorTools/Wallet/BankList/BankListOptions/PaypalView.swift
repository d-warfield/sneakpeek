//
//  PaypalView.swift
//  sneakpeek (iOS)
//
//  Created by Dennis Warfield on 4/14/22.
//

import SwiftUI

struct PaypalView: View {
    @Environment(\.dismiss) var dismiss
    @State private var paypal: String = ""
    @EnvironmentObject var banking: BankingServiceModel
    
    
    var body: some View {
        
        VStack(alignment: .leading) {
            TextField(
                "Paypal Email",
                text: $paypal
            )
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
            .onAppear {
                self.paypal = banking.bankingData.paypalEmail!
            }
            .onChange(of: paypal) { newValue in
                
                paypal = newValue.replacingOccurrences(of: " ", with: "")
    
            }
            Divider()
             .frame(height: 1)
            Spacer()
        }
        .padding()
        .navigationBarTitle("Paypal", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    Task {
                        banking.bankingData.paypalEmail = paypal
                        try await banking.updateBank(bankType: "paypalEmail", bankText: paypal)
                    }
                    dismiss()

                } label: {
                    Text("Save")
                        .buttonStyle(DefaultButtonStyle())
                       

                }
            }
    }
       
        
    }
}

struct PaypalView_Previews: PreviewProvider {
    static var previews: some View {
        PaypalView()
    }
}
