//
//  KeychainStorage.swift
//  sneakpeek (iOS)
//
//  Created by Dennis Warfield on 4/13/22.
//

import Foundation
import SwiftKeychainWrapper

enum KeychainStorage {
    static let key = "credentials"
    
    static func getCredentials() -> Credentials? {
        if let myCredentialsString = KeychainWrapper.standard.string(forKey: self.key) {
            
            return Credentials.decode(myCredentialsString)
        } else {
            return nil
        }
    }
    
    static func saveCredentials(_ credentials: Credentials) -> Bool {
        if KeychainWrapper.standard.set(credentials.encoded(), forKey: self.key) {
            return true
        } else {
            return false
        }
    }
    
    static func deleteCredentials() -> Bool {
        KeychainWrapper.standard.removeObject(forKey: self.key)
        if (getCredentials() == nil) {
            return true
        
        } else {
            return false
        }
        

    }
}
