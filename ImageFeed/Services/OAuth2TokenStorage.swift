//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Rodion Kim on 02/09/2024.
//

import Foundation

final class OAuth2TokenStorage {
    private(set) var token: String? {
        get {
            return UserDefaults.standard.string(forKey: "accessToken")
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "accessToken")
        }
    }
    
    func storeToken(_ newToken: String) {
        self.token = newToken
    }
    
    func clearToken() {
        self.token = nil
    }
}

