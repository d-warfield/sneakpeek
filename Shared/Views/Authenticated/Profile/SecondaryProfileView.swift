//
//  SecondaryProfileView.swift
//  sneakpeek (iOS)
//
//  Created by Dennis Warfield on 4/15/22.
//

import SwiftUI

let group_1 = ["1.99_option_1", "1.99_option_2"];
let group_2 = ["4.99_option_1", "4.99_option_2"];
let group_3 = ["9.99_option_1", "9.99_option_2"];
let group_4 = ["14.99_option_1", "14.99_option_2"];





struct SecondaryProfileView: View {
    @EnvironmentObject var user: UserFetchServiceResultModel
    @EnvironmentObject var product: ProductService
    
    func actionSheet() {
        guard let data = URL(string: "sneakpeek.to/@\(user.secondaryUserData.username!)") else { return }
        let av = UIActivityViewController(activityItems: [data], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }
    
    var body: some View {
        ZStack {
            if user.isLoading {
                ZStack{
                    ProgressView()
                }
                .frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    maxHeight: .infinity,
                    alignment: .center
                )
                
                
            } else {
                
                
                VStack {
                    ProfileHeader(secondaryUserData: user.secondaryUserData, primaryUserIsActive: false)
                    
                    
                    Button {
                        Task {
                            do {
                                var prod = [""];
                                switch user.secondaryUserData.monthlySubFee {
                                case 1.99:
                                    prod = group_1
                                    break;
                                case 4.99:
                                    prod = group_2
                                    break;
                                case 9.99:
                                    prod = group_3
                                    break;
                                case 14.99:
                                    prod = group_4
                                    break;
                                default:
                                    break;
                                }
                                let completedSuccessfully = try await product.purchaseProduct(userId: user.secondaryUserData.userId!, products: prod)
                                if (completedSuccessfully) {
                                    print("Completed")
                                } else {
                                    print("Failed to purchase, all subscriptions might be used")
                                }
                            } catch {
                                print("error while bying")
                            }
                        }
                    } label: {
                        Text("Subscribe・$\(user.secondaryUserData.monthlySubFee ?? 0.00, specifier: "%.2f") monthly")
                            .frame(minWidth: 300, maxWidth: .infinity)
                            
                    }
                    
                    .buttonStyle(DefaultButtonStyle())
                    
                    Text("You can cancel at anytime")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding([.horizontal], 60)
                    Spacer()
                }
                .frame(
                    minWidth: 0,
                    maxWidth: .infinity
                    
                )
                
                .toolbar {
                    
                    ToolbarItem(placement: .principal) {
                        
                        if (user.secondaryUserData.pronoun!.count > 0) {
                            VStack {
                                Text("\(user.secondaryUserData.displayName ?? "")")
                                    .font(.headline)
                                Text("\(user.secondaryUserData.pronoun ?? "")")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        } else {
                            Text("\(user.secondaryUserData.displayName ?? "")")
                                .font(.headline)
                            
                        }
                        
                    }
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button {
                            actionSheet()
                        } label: {
                            Image(systemName: "square.and.arrow.up")
                            
                                .padding(EdgeInsets(top: -4.5, leading: 0, bottom: 0, trailing: 0))
                            
                            
                        }
                        Menu {
                            Button(action: {},label: {
                                Label("Report", systemImage: "person.crop.circle.badge.exclamationmark")
                            })
                            Button(action: {},label: {
                                Label("Block", systemImage: "person.fill.xmark")
                                
                            })
                        } label: {
                            Image(systemName: "info.circle")
                            
                            
                            
                        }
                        
                    }
                }
            }
        }
    }
}

struct SecondaryProfileView_Previews: PreviewProvider {
    static var previews: some View {
        SecondaryProfileView()
    }
}
