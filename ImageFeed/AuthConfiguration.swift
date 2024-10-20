//
//  AuthConfiguration.swift
//  ImageFeed
//
//  Created by Rodion Kim on 28/08/2024.
//

import Foundation

// Main account
enum Constants {
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let accessKey = "kBKN4_3jikjBfUJ_w75Dfyl41FknpAkJRFz87qq-bzU"
    static let secretKey = "LlXqT8JxVLL7qPaJdmeHmUabdjpi6_rAWfU_TG6sRPQ"
    
    static let defaultBaseURL = "https://api.unsplash.com/"
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}

// Secondary account
enum ConstantsSecondary {
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let accessKey = "8TI6mh9Nfb2IApDMHyrWwU6Xo0NENZF6nBvSpXPhzF8"
    static let secretKey = "MJG4v5XZ9sKYTAYUuS2R0NvBbnlxxlFVphcrw__mlu0"
    
    static let defaultBaseURL = "https://api.unsplash.com/"
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: String
    let unsplashAuthorizeURLString: String
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, defaultBaseURL: String, unsplashAuthorizeURLString: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.unsplashAuthorizeURLString = unsplashAuthorizeURLString
    }
    
    static var main: AuthConfiguration {
        return AuthConfiguration(
            accessKey: Constants.accessKey,
            secretKey: Constants.secretKey,
            redirectURI: Constants.redirectURI,
            accessScope: Constants.accessScope,
            defaultBaseURL: Constants.defaultBaseURL,
            unsplashAuthorizeURLString: Constants.unsplashAuthorizeURLString
        )
    }
    
    static var secondary: AuthConfiguration {
        return AuthConfiguration(
            accessKey: ConstantsSecondary.accessKey,
            secretKey: ConstantsSecondary.secretKey,
            redirectURI: ConstantsSecondary.redirectURI,
            accessScope: ConstantsSecondary.accessScope,
            defaultBaseURL: ConstantsSecondary.defaultBaseURL,
            unsplashAuthorizeURLString: ConstantsSecondary.unsplashAuthorizeURLString
        )
    }
}

