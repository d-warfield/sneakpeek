//
//  PaymentsView.swift
//  sneakpeek (iOS)
//
//  Created by Dennis Warfield on 4/14/22.
//

import SwiftUI

struct PaymentsView: View {
    
    @EnvironmentObject var banking: BankingServiceModel
    @EnvironmentObject var user: UserFetchServiceResultModel

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
                
                if (banking.paymentData.count == 0) {
                    
                    VStack {
                        Text("No payments")
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
                            
                            ForEach(banking.paymentData, id: \.self) { result in
                                HStack {
                                    
                                    VStack(alignment: .leading, spacing: 2)   {
                                        Spacer()

                                        Text("Paid")
                                            .font(.headline).bold()
                                            .foregroundColor(.primary)
                                        Text("\(convertTimestamp(unixTimestamp: result.createdAt!))")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                        Spacer()
                                        
                                    }
                                    Spacer()
                                    
                                    
                                    VStack(alignment: .trailing, spacing: 0) {
                                        Text("+ $fix")
                                            .font(.system(size: 16, weight: .bold, design: .rounded))
                                            .padding([.bottom], 5)
                                       
                                    }
                                }
                                
                                .padding([.vertical], 5)
                            }
                        }
                        
                        
                    }
                    .navigationBarTitle("Payments", displayMode: .inline)
                    .listStyle(.automatic)
                }
              
                
            }
            
            
            
        }
        .background(Color("listBackground"))

        .onAppear(perform: {
            
            
            self.isLoading = true
            Task {
                try await banking.getPaymentActivity()
                
                self.isLoading = false
                
            }
        })
        .navigationBarTitle("Payments", displayMode: .inline)

    }
    
}


struct PaymentsView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentsView()
    }
}
