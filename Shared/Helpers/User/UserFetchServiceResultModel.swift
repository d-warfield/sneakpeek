
//
//  UserModel.swift
//  sneakpeek (iOS)
//
//  Created by Dennis Warfield on 4/13/22.
//

import Foundation
import JWTDecode
import SwiftKeychainWrapper




class UserFetchServiceResultModel: ObservableObject {
    @Published var userData = UserData()
    @Published var secondaryUserData = SecondaryUserData()
    @Published var uploadProfilePicture = UploadProfilePicture()
    @Published var uploadProfilePictureIsLoading = false
    @Published var isLoading: Bool = true
    @Published var currentTab = 0

    var credentialsViewModel: Credentials?
    
    
    
    func fetchUser() async throws  -> UserData? {
        
        
        
        
        
        print("FETCHING USER........")
        
        await refreshAccessToken()
        
        let credentials = KeychainStorage.getCredentials()
        
        
        
        

            let accessToken = credentials?.AccessToken
            let url = URL(string: "\(API_URL)/profile")!
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(accessToken, forHTTPHeaderField: "Authorization")
            request.httpMethod = "GET"
            
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            let response = try JSONDecoder().decode(UserData.self, from: data)
            DispatchQueue.main.async {
                
                self.userData = response
            }
            
      
        
        await updateLastActive()
        return UserData()
    }
    
    
    
    
    
    func fetchOtherUser(userId: String) async throws  -> SecondaryUserData? {
        
        
        self.isLoading = true
        
        
        
        let credentials = KeychainStorage.getCredentials()
        if (credentials != nil) {
            let accessToken = credentials?.AccessToken
            let url = URL(string: "\(API_URL)/profile/\(userId)")!
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(accessToken, forHTTPHeaderField: "Authorization")
            request.httpMethod = "POST"
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            
            let secondaryUserDataResults = try JSONDecoder().decode(SecondaryUserData.self, from: data)
            
            DispatchQueue.main.async {
                self.secondaryUserData = secondaryUserDataResults
                self.isLoading = false
            }
        } else {
            print("NO CREDENTIALS")
        }
        return SecondaryUserData()
    }
    
    func updateUsername(username: String) async throws {
        self.userData.username = username
        let credentials = KeychainStorage.getCredentials()
        let accessToken = credentials?.AccessToken
        let url = URL(string: "\(API_URL)/update/username")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(accessToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = "PUT"
        let body: [String: AnyHashable] = [
            "username": username
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        do {
            let (_, _) = try await URLSession.shared.data(for: request)
        } catch {
            debugPrint("Error loading \(url): \(String(describing: error))")
        }
    }
    
    func updateDisplayName(displayName: String) async throws {
        self.userData.displayName = displayName
        let credentials = KeychainStorage.getCredentials()
        let accessToken = credentials?.AccessToken
        let url = URL(string: "\(API_URL)/update/displayName")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(accessToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = "PUT"
        let body: [String: AnyHashable] = [
            "displayName": displayName
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        do {
            let (_, _) = try await URLSession.shared.data(for: request)
        } catch {
            debugPrint("Error loading \(url): \(String(describing: error))")
        }
    }
    
    func updateBio(bio: String) async throws {
        self.userData.bio = bio
        let credentials = KeychainStorage.getCredentials()
        let accessToken = credentials?.AccessToken
        let url = URL(string: "\(API_URL)/update/bio")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(accessToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = "PUT"
        let body: [String: AnyHashable] = [
            "bio": bio
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        do {
            let (_, _) = try await URLSession.shared.data(for: request)
        } catch {
            debugPrint("Error loading \(url): \(String(describing: error))")
        }
    }
    
    
    func updatePronoun(pronoun: String) async throws {
        self.userData.pronoun = pronoun
        let credentials = KeychainStorage.getCredentials()
        let accessToken = credentials?.AccessToken
        let url = URL(string: "\(API_URL)/update/pronoun")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(accessToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = "PUT"
        let body: [String: AnyHashable] = [
            "pronoun": pronoun
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        do {
            let (_, _) = try await URLSession.shared.data(for: request)
        } catch {
            debugPrint("Error loading \(url): \(String(describing: error))")
        }
    }
    
    func updateAccountType(accountType: String) async throws {
        self.userData.accountType = accountType
        let credentials = KeychainStorage.getCredentials()
        let accessToken = credentials?.AccessToken
        let url = URL(string: "\(API_URL)/update/accountType")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(accessToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        let body: [String: AnyHashable] = [
            "accountType": accountType
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        do {
            let (_, _) = try await URLSession.shared.data(for: request)
            
            DispatchQueue.main.async {
                self.userData.accountType = accountType
                
            }
            
        } catch {
            debugPrint("Error loading \(url): \(String(describing: error))")
        }
    }
    
    func updateLastActive() async {
        
        let credentials = KeychainStorage.getCredentials()
        let accessToken = credentials?.AccessToken
        let url = URL(string: "\(API_URL)/last/active")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(accessToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
        do {
            let (_, _) = try await URLSession.shared.data(for: request)
            
        } catch {
            debugPrint("Error loading \(url): \(String(describing: error))")
        }
    }
    
    
    func updateProfilePictureUrl(avatarImageData: Data) async throws {
        
        
        
        self.uploadProfilePictureIsLoading = true
        // get profile picture url and upload url
        let credentials = KeychainStorage.getCredentials()
        let accessToken = credentials?.AccessToken
        let url = URL(string: "\(API_URL)/profile/picture")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(accessToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        let body: [String: AnyHashable] = [
            "fileExtension": "jpeg"
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            self.uploadProfilePicture = try JSONDecoder().decode(UploadProfilePicture.self, from: data)
            
            
            
        } catch {
            debugPrint("Error loading \(url): \(String(describing: error))")
        }
        
        
        
        
        
        // upload to s3 bucket
        let uploadUrl = URL(string: uploadProfilePicture.url!)!
        var requestToUpload = URLRequest(url: uploadUrl)
        requestToUpload.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")
        //        request.setValue(accessToken, forHTTPHeaderField: "Authorization")
        requestToUpload.httpMethod = "PUT"
        
        
        requestToUpload.httpBody = avatarImageData
        do {
            let (data, _) = try await URLSession.shared.data(for: requestToUpload)
            //            self.userData.profilePictureUrl = uploadProfilePicture.profilePictureUrl
        } catch {
            debugPrint("Error loading \(url): \(String(describing: error))")
        }
        
        DispatchQueue.main.async {
            self.userData.profilePictureUrl = self.uploadProfilePicture.profilePictureUrl
            self.uploadProfilePictureIsLoading = false

            
        }
        
        
        
        
    }
    
    
    
    func refreshAccessToken() async {
        let credentials = KeychainStorage.getCredentials()
        
        
        let refreshToken =  credentials?.RefreshToken
        
        
        
        let accessToken = credentials?.AccessToken
        
        let url = URL(string: "\(API_URL)/users/refresh")!
        
        
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(accessToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        let body: [String: AnyHashable] = [
            "refresh_token": refreshToken
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let authenticationResults: RefreshAuthenticationResults = try JSONDecoder().decode(RefreshAuthenticationResults.self, from: data)
            KeychainWrapper.standard.removeObject(forKey: "RefreshToken")
            KeychainStorage.saveCredentials(Credentials(AccessToken: authenticationResults.AuthenticationResult.AccessToken, RefreshToken: refreshToken!, IdToken: authenticationResults.AuthenticationResult.IdToken))
            
            
            
        } catch {
            print("Could not update refresh token")
            KeychainStorage.deleteCredentials()
        }
        
        
    }
}







struct UserData: Codable {
    var userId: String?
    var accountType: String?
    var displayName: String?
    var username: String?
    var lastActive: Double?
    var profilePictureUrl: String?
    var bio: String?
    var pronoun: String?
    var totalPostsSent: Int?
    var subscriptions: Int?
    var subscribers: Int?
    var monthlySubFee: Float?
    var createdAt: Int?
}

struct SecondaryUserData: Codable {
    var userId: String?
    var accountType: String?
    var displayName: String?
    var username: String?
    var lastActive: Double?
    var profilePictureUrl: String?
    var bio: String?
    var pronoun: String?
    var monthlySubFee: Double?
    var totalPostsSent: Int?
}

struct UploadProfilePicture: Codable {
    var url: String?
    var profilePictureUrl: String?
}





struct RefreshAuthenticationResults: Decodable {
    var AuthenticationResult: RefreshAuthenticationResult
}

struct RefreshAuthenticationResult: Decodable {
    var AccessToken: String
    var ExpiresIn: Int
    var TokenType: String
    var IdToken: String
}


