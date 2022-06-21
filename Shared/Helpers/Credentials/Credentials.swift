//
//  Credentials.swift
//  sneakpeek (iOS)
//
//  Created by Dennis Warfield on 4/13/22.
//

import Foundation


struct Credentials: Codable {
    
    var AccessToken: String
    var RefreshToken: String
    var IdToken: String
    
    func encoded() -> String {
        let encoder = JSONEncoder()
        let credentialsData = try! encoder.encode(self)
        return String(data: credentialsData, encoding: .utf8)!
    }
    
    static func decode(_ credentialsString: String) -> Credentials {
        let decoder = JSONDecoder()
        let jsonData = credentialsString.data(using: .utf8)
        return try! decoder.decode((Credentials.self), from: jsonData!)
    }
    
    
    
}
