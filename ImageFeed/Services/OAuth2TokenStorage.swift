//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Rodion Kim on 02/09/2024.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    private(set) var token: String? {
        get {
            let token: String? = KeychainWrapper.standard.string(forKey: "accessToken")
            guard let token else { return nil }
            return token
        }
        
        set {
            guard let newValue else { return }
            let isSuccess = KeychainWrapper.standard.set(newValue, forKey: "accessToken")
            guard isSuccess else {
                print("Failed at writing token to keychain")
                return
            }
        }
    }
    
    func storeToken(_ newToken: String) {
        self.token = newToken
    }
    
    func clearToken() {
        self.token = nil
    }
}

