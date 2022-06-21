//
//  CodeModel.swift
//  sneakpeek (iOS)
//
//  Created by Dennis Warfield on 4/11/22.
//

import Foundation


class AuthViewModel: ObservableObject {
    @Published var auth = false
    @Published var sessionData: SessionData?
    @Published var isAuthLoading = true
    @Published var isAuthenticated = false
    @Published var isVerifyingCode = false
    @Published var didSendCode = false

    
    var user = UserFetchServiceResultModel()
    var banking = BankingServiceModel()
    var inbox = InboxServiceModel()
    
    var sessionId = ""
    var AccessToken = ""
    var IdToken = ""
    var RefreshToken = ""
    
    func initAuth(phoneNumber: String) {
        
        print("INIT AUTH................")
        
        self.didSendCode = true
        
        guard let url = URL(string: "\(API_URL)/users/initAuth") else {
            return
        }
        
        var request = URLRequest(url:url)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "username": phoneNumber
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        let task = URLSession.shared.dataTask(with: request) {data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let sessionData: SessionData =  try JSONDecoder().decode(SessionData.self, from: data)
                self.sessionId = sessionData.Session
                
                
            } catch {
                print(error)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { // Change `2.0` to the desired number of seconds.
            self.isAuthLoading = false
        }
        
        task.resume()
        
    }
    
    
    func verifyCode(phoneNumber: String, secret: String) async -> Bool {
        self.isVerifyingCode = true
        
        guard let url = URL(string: "\(API_URL)/users/verifyAuth") else {
            return false;
        }
        
        var request = URLRequest(url:url)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "session": sessionId,
            "username": phoneNumber,
            "secret": secret
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        do {
            let (data,_) = try await URLSession.shared.data(for: request)
            
            do {
                let authenticationResults: AuthenticationResults = try JSONDecoder().decode(AuthenticationResults.self, from: data)
                self.AccessToken = authenticationResults.AuthenticationResult.AccessToken
                self.IdToken = authenticationResults.AuthenticationResult.IdToken
                self.RefreshToken = authenticationResults.AuthenticationResult.RefreshToken
                
                KeychainStorage.saveCredentials(Credentials(AccessToken: authenticationResults.AuthenticationResult.AccessToken, RefreshToken: authenticationResults.AuthenticationResult.RefreshToken, IdToken: authenticationResults.AuthenticationResult.IdToken))
             
                
                DispatchQueue.main.async {
                    sleep(1)
                    
//                    self.isVerifyingCode = false
//                    self.isAuthenticated = true
                }
            } catch {
                print("ERROR", error)
                do {
                    let sessionResult: SessionResult = try JSONDecoder().decode(SessionResult.self, from: data)
                    self.sessionId = sessionResult.Session
                } catch {
                    print("failed to get session", error)
                }
                DispatchQueue.main.async {
                    self.isVerifyingCode = false
                }
            }
        } catch {
            print("ERROR", error)
        }
        
        return true;
    }
    
    func checkAuthStatus() {
        let authenticated = KeychainStorage.getCredentials()
        DispatchQueue.main.async {

            if authenticated == nil {
                self.isAuthenticated = false
            } else {
                self.isAuthenticated = true
            }
        }
    }
}

struct SessionData: Decodable {
    var ChallengeName: String
    var ChallengeParameters: ChallengeParametersData
    var Session: String
}

struct ChallengeParametersData: Decodable {
    var USERNAME: String
    var phone: String
}

struct VerifyData: Decodable {
    var ChallengeName: String
    var Session: String
    var ChallengeParameters: VerifyChallengeParametersData
}

struct VerifyChallengeParametersData: Decodable {
    var phone: String
}

struct AuthenticationResults: Decodable {
    var AuthenticationResult: AuthenticationResult
}

struct SessionResult: Decodable {
    var Session: String
}

struct AuthenticationResult: Decodable {
    var AccessToken: String
    var ExpiresIn: Int
    var TokenType: String
    var RefreshToken: String
    var IdToken: String
}






