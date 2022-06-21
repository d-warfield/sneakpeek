//
//  InboxServiceModel.swift
//  sneakpeek (iOS)
//
//  Created by Dennis Warfield on 4/14/22.
//



import Foundation
import JWTDecode



class InboxServiceModel: ObservableObject {
    @Published var receivedResults: [ReceivedResult] = []
    @Published var subscribersProfilePictureUrls: [SubscriberProfilePictureUrl] = []
    @Published var postAnalytics = PostAnalytics()
    @Published var isLoading: Bool = true
    @Published var hasFetchedReceived = false
    
    
    
    func fetchReceived() async throws   {
        print("FETCHING INBOX.......")
        
        let credentials = KeychainStorage.getCredentials()
        let accessToken = credentials?.AccessToken
        let url = URL(string: "\(API_URL)/feed")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(accessToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        let (data, _) = try! await URLSession.shared.data(for: request)
        let receivedResults = try JSONDecoder().decode([ReceivedResult].self, from: data)
        
        
        try await fetchSubscribersProfileImages()
        
        DispatchQueue.main.async {
            self.receivedResults = receivedResults
            self.isLoading = false
        }
        
    }
    
    func updateOpened(postId: String, postOwner: String) async throws {
        
        let credentials = KeychainStorage.getCredentials()
        let accessToken = credentials?.AccessToken
        let url = URL(string: "\(API_URL)/feed/post/opened")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(accessToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        let body: [String: AnyHashable] = [
            "postId": postId,
            "postOwner": postOwner
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        do {
            let (_, _) = try! await URLSession.shared.data(for: request)
            
        } catch {
            debugPrint("Error loading \(url): \(String(describing: error))")
        }
    }
    
    
    func updateTotalViews(userId: String, postId: String) async throws {
        
        let credentials = KeychainStorage.getCredentials()
        let accessToken = credentials?.AccessToken
        let url = URL(string: "\(API_URL)/analytics/increment/views")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(accessToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        let body: [String: AnyHashable] = [
            "userId": userId,
            "postId": postId
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        do {
            let (_, _) = try! await URLSession.shared.data(for: request)
            
        } catch {
            debugPrint("Error loading \(url): \(String(describing: error))")
        }
    }
    
    func updateTotalTimeViewed(userId: String, postId: String, totalTimeViewed: Float) async throws {
        
        
        
        
        let credentials = KeychainStorage.getCredentials()
        let accessToken = credentials?.AccessToken
        let url = URL(string: "\(API_URL)/analytics/add/totalTimeViewed")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(accessToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        let body: [String: AnyHashable] = [
            "userId": userId,
            "postId": postId,
            "totalTimeViewed": Int(totalTimeViewed)
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        do {
            let (_, _) = try! await URLSession.shared.data(for: request)
            
        } catch {
            debugPrint("Error loading \(url): \(String(describing: error))")
        }
    }
    
    
    func fetchPostAnalytics(userId: String, postId: String) async throws {
        
        let credentials = KeychainStorage.getCredentials()
        let accessToken = credentials?.AccessToken
        let url = URL(string: "\(API_URL)/analytics/post")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(accessToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        let body: [String: AnyHashable] = [
            "userId": userId,
            "postId": postId
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let response = try JSONDecoder().decode(PostAnalytics.self, from: data)
        
        DispatchQueue.main.async {
            self.postAnalytics = response
            
        }
    }
    
    func fetchSubscribersProfileImages() async throws {
        
        let credentials = KeychainStorage.getCredentials()
        let accessToken = credentials?.AccessToken
        let url = URL(string: "\(API_URL)/subscribers/profiles/images")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(accessToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
//        let body: [String: AnyHashable] = [
//            "userId": userId
//        ]
//        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
//
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let response = try JSONDecoder().decode([SubscriberProfilePictureUrl].self, from: data)
        
        
        
        
        DispatchQueue.main.async {
            self.subscribersProfilePictureUrls = response
            
        }
    }
    
    
    
}





struct ReceivedResult: Hashable, Codable {
    var postId: String?
    var displayName: String?
    var profilePictureUrl: String?
    var opened: Bool? = true
    var mediaType: String?
    var signedPostUrl: String?
    var createdAt: Double?
    var notificationType: String?
    var amount: Double?
    var userId: String?
    var totalDelivered: Int?
}

struct SubscriberProfilePictureUrl: Hashable, Codable {

    var profilePictureUrl: String?
 
}


struct PostAnalytics: Hashable, Codable {
    var userId: String?
    var postId: String?
    var mediaType: String?
    var createdAt: Double?
    var totalViews: Int?
    var totalRecipients: Int?
    var totalTimeViewed: Int?
    
}


