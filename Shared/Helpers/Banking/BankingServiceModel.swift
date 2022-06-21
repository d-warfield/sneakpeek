//
//  BankingServiceModel.swift
//  sneakpeek (iOS)
//
//  Created by Dennis Warfield on 4/14/22.
//


import Foundation
import JWTDecode



class BankingServiceModel: ObservableObject {
    @Published var bankingData = BankingData()
    @Published var withdrawData: [WithdrawData] = []
    @Published var paymentData: [PaymentData] = []
    @Published  var loading: Bool = true
    @Published  var withdrawsLoading: Bool = true
    
    
    
    
    
    func fetchBanking() async throws  -> BankingData? {
        
        
        self.loading = true
        
        
        let credentials = KeychainStorage.getCredentials()
        if (credentials != nil) {
            let accessToken = credentials?.AccessToken
            let url = URL(string: "\(API_URL)/banking")!
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(accessToken, forHTTPHeaderField: "Authorization")
            request.httpMethod = "GET"
            
            do {
                let (data, _) = try await URLSession.shared.data(for: request)
           
                let response = try JSONDecoder().decode(BankingData.self, from: data)
                
                
                DispatchQueue.main.async {
                    self.bankingData = response
                    self.loading = false
                }
  
                
            } catch {
                debugPrint("Error loading \(url): \(String(describing: error))")
            }
            
            
        } else {
            print("NO BANKING DATA")
        }
        return BankingData()
    }
    
    func updateMonthlySubFee(monthlySubFee: Double) async throws {
        self.bankingData.monthlySubFee = monthlySubFee
        let credentials = KeychainStorage.getCredentials()
        let accessToken = credentials?.AccessToken
        let url = URL(string: "\(API_URL)/update/monthlySubFee")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(accessToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        let body: [String: AnyHashable] = [
            "monthlySubFee": monthlySubFee
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        do {
            let (_, _) = try! await URLSession.shared.data(for: request)
        } catch {
            debugPrint("Error loading \(url): \(String(describing: error))")
        }
    }
    
    func updateBank(bankType: String, bankText: String) async throws {
        
        if bankType == "paypal" {
            self.bankingData.paypalEmail = bankText
        } else {
            self.bankingData.venmoHandle = bankText
        }
        
        let credentials = KeychainStorage.getCredentials()
        let accessToken = credentials?.AccessToken
        let url = URL(string: "\(API_URL)/update/bank")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(accessToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = "PUT"
        let body: [String: AnyHashable] = [
            "bankType": bankType,
            "bankText": bankText
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        do {
            let (_, _) = try! await URLSession.shared.data(for: request)
        } catch {
            debugPrint("Error loading \(url): \(String(describing: error))")
        }
    }
    
    func withdrawBalance() async throws {
        let credentials = KeychainStorage.getCredentials()
        let accessToken = credentials?.AccessToken
        let url = URL(string: "\(API_URL)/users/banking/withdraw/balance")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(accessToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
        do {
            let (_, _) = try! await URLSession.shared.data(for: request)
            self.bankingData.balance = 0
        } catch {
            debugPrint("Error loading \(url): \(String(describing: error))")
        }
    }
    
    func getWithdrawActivity() async throws {
        let credentials = KeychainStorage.getCredentials()
        let accessToken = credentials?.AccessToken
        let url = URL(string: "\(API_URL)/withdraws")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(accessToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        do {
            let (data, _) = try! await URLSession.shared.data(for: request)
            self.withdrawData = try JSONDecoder().decode([WithdrawData].self, from: data)
            
            
        } catch {
            debugPrint("Error loading \(url): \(String(describing: error))")
        }
    }
    
    func getPaymentActivity() async throws {
        let credentials = KeychainStorage.getCredentials()
        let accessToken = credentials?.AccessToken
        let url = URL(string: "\(API_URL)/user/payments")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(accessToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        do {
            let (data, _) = try! await URLSession.shared.data(for: request)
            self.paymentData = try JSONDecoder().decode([PaymentData].self, from: data)
            
        } catch {
            debugPrint("Error loading \(url): \(String(describing: error))")
        }
    }
    
    
    
    
}







struct BankingData: Codable {
    var balance: Double?
    var monthlySubFee: Double?
    var paypalEmail: String?
    var venmoHandle: String?
}

struct WithdrawData: Hashable, Codable {
    var paymentId: String?
    var createdAt: Int?
    var totalPayout: Double?
    var paid: Bool?
}

struct PaymentData: Hashable, Codable {
    var createdAt: Int?
    var receiptId: String?
    var subscribedToUserId: Double?
    
    
}





