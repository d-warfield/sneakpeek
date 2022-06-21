//
//  WalletView.swift
//  sneakpeek (iOS)
//
//  Created by Dennis Warfield on 4/11/22.
//

import SwiftUI

struct WalletView: View {
    @EnvironmentObject var banking: BankingServiceModel
    
    
    var body: some View {
        
        
        
        ZStack {
            
            if banking.loading{
                ProgressView()
            }
            else {
                
                ZStack(alignment: .top) {
                    
                    
                    VStack {
                        VStack {
                            
                            VStack {
                                Text("$\(banking.bankingData.balance ?? Double(Int(0.00)),specifier: "%.2f")")
                                    .font(.system(size: 50, weight: .bold, design: .rounded))
                                Text("Your balance")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .padding([.top], 80)
                            .padding([.bottom], 40)
                            
                            
                            
                            if (banking.bankingData.paypalEmail!.count != 0 || banking.bankingData.venmoHandle!.count != 0) {
                             
                                VStack {
                                    
                                    
                                    Button { Task {
                                        if banking.bankingData.balance! > 0 {
                                            try await banking.withdrawBalance()

                                        }
                                    } } label: {
                                        
                                        Text("Cash Out")
                                    }
                                    .buttonStyle(DefaultButtonStyle())
                                }
                                
                                
                            }
                            
                        }
                        
                        List {
                            Section(footer: Text("Connect your paypal for payouts").font(.subheadline).foregroundColor(.secondary)) {
                                
                                
                                NavigationLink(destination: BankListView()) {
                                    HStack {
                                        
                                        Text("Your banks")
                                        Spacer()
                                        if banking.bankingData.paypalEmail!.count == 0 && banking.bankingData.venmoHandle!.count == 0 {
                                            Text("Setup")
                                                
                                                .foregroundColor(.pink)
                                        }
                                        
                                    }
                                    
                                }
                                
                                
                                
                                
                            }
                            
                            Section(footer: Text("View your payments and withdraws").font(.subheadline).foregroundColor(.secondary)) {
                                
                                NavigationLink(destination: PaymentsView()) {
                                    HStack {
                                        Text("Payments")
                                        
                                    }
                                    
                                }
                                
                                NavigationLink(destination: WithdrawsView()) {
                                    HStack {
                                        Text("Withdraws")
                                        
                                    }
                                    
                                }
                              
                            }
                            
                            
                            
                            
                            
                            
                            
                        }
                        .listStyle(.automatic)
                        
                        
                        
                        
                        
                        
                        
                        
                        Spacer()
                        
                    }
                    .navigationBarTitle("Wallet", displayMode: .inline)
                    Spacer()
                    
                }
                .background(Color("listBackground"))
            }
        }
        
        
        
        
        
        
        
        
    }
    
}



struct WalletView_Previews: PreviewProvider {
    static var previews: some View {
        WalletView()
            .environmentObject(BankingServiceModel())
    }
}
