//
//  SubscriptionFeeView.swift
//  sneakpeek (iOS)
//
//  Created by Dennis Warfield on 4/14/22.
//

import SwiftUI

struct AccountTypeView: View {
    @EnvironmentObject var banking: BankingServiceModel
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var user: UserFetchServiceResultModel
    @State var accountType = ""

    
    
    
    var body: some View {
        VStack {
            
            
            List {
                Section(footer: Text("You won't be able to charge a subscription")) {
                    Button {
                        
                        self.accountType = "subscriber"
                        
                    } label: {
                    HStack {
                        Text("Subscriber")
                            .foregroundColor(.primary)
                        Spacer()
                        
                        if (accountType == "subscriber") {
                            Image(systemName: "checkmark")
                            
                        }
                        
                    }
                    }

                }
                Section(footer: Text("You'll be able to charge a monthly subscription fee to earn money")) {
                    
                    Button {
                        
                        self.accountType = "creator"
                        
                    } label: {
                        HStack {
                            Text("Creator")
                                .foregroundColor(.primary)

                            Spacer()
                            if (accountType == "creator") {
                                Image(systemName: "checkmark")
                                    
                                    
                                
                            }
                            
                        }
                    }
                    
                   

                }
                
            }
            .listStyle(.automatic)
            
        }
        
        .onAppear(perform: {self.accountType = user.userData.accountType!})
        .navigationBarTitle("Account Type", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    Task {
                        try await user.updateAccountType(accountType: accountType)
                        dismiss()
                    }
                } label: {
                    Text("Save")
                }
            }
            
        }
    
}
}

struct AccountTypeView_Previews: PreviewProvider {
    static var previews: some View {
        AccountTypeView()
    }
}



