//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Rodion Kim on 13/10/2024.
//

import UIKit
import WebKit
import Kingfisher

final class ProfileLogoutService {
    static let shared = ProfileLogoutService()
    
    private init() { }
    
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let imageListService = ImageListService.shared
    
    func logout(completion: @escaping () -> Void) {
        print("logging out...")
        cleanData()
        completion()
    }
    
    private func cleanData() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
        
        imageListService.cleanList()
        profileService.cleanProfile()
        profileImageService.cleanProfileImage()
        
        OAuth2TokenStorage.clearToken()
        KingfisherManager.shared.cache.clearCache()
    }
}
