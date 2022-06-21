//
//  VenmoView.swift
//  sneakpeek (iOS)
//
//  Created by Dennis Warfield on 4/14/22.
//

import SwiftUI

struct VenmoView: View {
    @Environment(\.dismiss) var dismiss
    @State private var venmo: String = ""
    @EnvironmentObject var banking: BankingServiceModel
    
    
    
    var body: some View {
        
        VStack {
            HStack(spacing: 2) {
                
                Text("@")
                TextField(
                    "Venmo Handle",
                    text: $venmo
                )
                .textInputAutocapitalization(.never)
                .onAppear {
                    self.venmo = banking.bankingData.venmoHandle!
                }
                .onChange(of: venmo) { newValue in
                    
                    venmo = newValue.replacingOccurrences(of: " ", with: "")
        
                }
                .disableAutocorrection(true)
            }
            
            
            Divider()
                .frame(height: 1)
            Spacer()
            
        }
        
        .padding()
        .navigationBarTitle("Venmo", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    Task {
                        banking.bankingData.venmoHandle = venmo
                        try await banking.updateBank(bankType: "venmoHandle", bankText: venmo)
                    }
                    dismiss()
                    
                } label: {
                    Text("Save")
                }
            }
        }
        
        
    }
}

struct VenmoView_Previews: PreviewProvider {
    static var previews: some View {
        VenmoView()
    }
}
