//
//  WithdrawView.swift
//  sneakpeek (iOS)
//
//  Created by Dennis Warfield on 4/14/22.
//

import SwiftUI

struct WithdrawsView: View {
    
    @EnvironmentObject var banking: BankingServiceModel
    @State private var isLoading = true
    
    
    func convertTimestamp(unixTimestamp: Int) -> String {
        let unixTimestamp = unixTimestamp
        let dateFormatter = DateFormatter()
        
        let date = Date(timeIntervalSince1970: TimeInterval(unixTimestamp))
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
    
    var body: some View {
        
        VStack {
            
            
            if isLoading {
                VStack {
                    ProgressView()
                }
                .frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    maxHeight: .infinity,
                    alignment: .center
                )
                .background(Color("listBackground"))
                
            } else {
                
                
                if (banking.withdrawData.count == 0) {
                    
                    VStack {
                        Text("No withdraws")
                            .font(.body)
                    }
                    .frame(
                        minWidth: 0,
                        maxWidth: .infinity,
                        minHeight: 0,
                        maxHeight: .infinity,
                        alignment: .center
                    )
                    
                } else {
                    List {
                        
                        Section {
                            
                            ForEach(banking.withdrawData, id: \.self) { result in
                                HStack {
                                    
                                    VStack(alignment: .leading, spacing: 2)   {
                                        Spacer()
                                        
                                        Text("Withdraw")
                                            .font(.headline).bold()
                                            .foregroundColor(.primary)
                                        Text("\(convertTimestamp(unixTimestamp: result.createdAt!))")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                        Spacer()
                                        
                                    }
                                    Spacer()
                                    
                                    
                                    VStack(alignment: .trailing, spacing: 0) {
                                        Text("- $\(result.totalPayout!, specifier: "%.2f")")
                                            .font(.system(size: 16, weight: .bold, design: .rounded))
                                            .padding([.bottom], 5)
                                        
                                        if !result.paid! {
                                            HStack {
                                                
                                                
                                                Text("pending")
                                                    .font(.caption2)
                                                    .foregroundColor(.secondary)
                                                    .padding([.top], -2)
                                                
                                            }
                                            
                                            .padding([.vertical],5)
                                            .padding([.horizontal],7)
                                            .background(Color("listBackground")).clipShape(RoundedRectangle(cornerRadius:4))
                                            
                                            
                                            
                                        }
                                    }
                                }
                                
                                .padding([.vertical], 5)
                            }
                        }
                        
                        
                    }
                    .navigationBarTitle("Withdraws", displayMode: .inline)
                    .listStyle(.automatic)
                }
                
                
            }
            
            
            
        }
        .background(Color("listBackground"))
        .navigationBarTitle("Withdraws", displayMode: .inline)
        .onAppear(perform: {
            
            
            self.isLoading = true
            Task {
                try await banking.getWithdrawActivity()
                
                self.isLoading = false
                
            }
        })
    }
    
}


struct WithdrawsView_Previews: PreviewProvider {
    static var previews: some View {
        WithdrawsView()
    }
}
