//
//  SearchForUserModel.swift
//  sneakpeek (iOS)
//
//  Created by Dennis Warfield on 4/13/22.
//


import Foundation
import JWTDecode



class SearchForUserModel: ObservableObject {
    @Published var searchResults: [SearchResult] = []
    @Published var isLoading: Bool = false
    
    
    
    
    func triggerSearch(username: String) async throws   {
        self.isLoading = true
        let credentials = KeychainStorage.getCredentials()
        let accessToken = credentials?.AccessToken
        let url = URL(string: "\(API_URL)/search/profile/\(username.lowercased())/20")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(accessToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        let (data, _) = try! await URLSession.shared.data(for: request)
        let searchResults = try JSONDecoder().decode([SearchResult].self, from: data)
        DispatchQueue.main.async {
            self.searchResults = searchResults
            self.isLoading = false
        }
    }
}





struct SearchResult: Hashable, Codable {
    var displayName: String?
    var profilePictureUrl: String?
    var username: String?
    var userId: String?
    
}

