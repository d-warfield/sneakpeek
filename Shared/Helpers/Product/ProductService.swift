//
//  ProductService.swift
//  sneakpeek (iOS)
//
//  Created by Dennis Warfield on 4/20/22.
//

import Foundation
import StoreKit
import SwiftUI

class ProductService: ObservableObject {
    var products: [Product] = []
    
    
    func requestProducts(products: [String]) async {
        do {
            let productList = try await Product.products(for: products )
            self.products = productList
            
        } catch {
            print("Couldn't fetch products")
        }
    }
    
    func isPurchased(product: Product) async -> Bool {
        guard let state = await product.currentEntitlement else { return false }
        
        switch state {
        case .verified(_):
            return true;
        case .unverified(_, _):
            return false;
        }
    }
    
    func purchaseProduct(userId: String, products: [String]) async -> Bool {
        await requestProducts(products: products)
        
        var completedSuccessfully = false;
        
        do {
            for product in self.products {
                let sub = await isPurchased(product: product)
                if (!sub) {
                    let result = try await product.purchase()
                    switch result {
                        case .success(let verification):
                            switch verification {
                                case .verified(let transaction):
                                do {
                                    let credentials = KeychainStorage.getCredentials()
                                    let accessToken = credentials?.AccessToken
                                    let url = URL(string: "\(API_URL)/payments")!
                                    var request = URLRequest(url: url)
                                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                                    request.setValue(accessToken, forHTTPHeaderField: "Authorization")
                                    request.httpMethod = "POST"
                                    let body: [String: AnyHashable] = [
                                        "receipt": verification.jwsRepresentation,
                                        "userId": userId
                                    ]
                                    request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)

                                    do {
                                        let (_, _) = try await URLSession.shared.data(for: request)
                                    } catch {
                                        debugPrint("Error loading \(url): \(String(describing: error))")
                                    }
                                    }
                                    catch { print("Couldn't read receipt data with error: " + error.localizedDescription) }

                                    await transaction.finish()
                                    print("SUBSCRIBED")
                                break
                            case .unverified(_, _):
                                break
                            }
                        case .userCancelled:
                            break
                        case .pending:
                            break
                        @unknown default:
                            break
                    }
                    completedSuccessfully = true
                    break;
                }
            }
        } catch {
            print("NO UPDATE")
        }
        return completedSuccessfully;
    }
}
