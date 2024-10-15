//
//  UrlConstructor.swift
//  ImageFeed
//
//  Created by Rodion Kim on 05/10/2024.
//

import Foundation

final class UrlRequestConstructor {
    
    static func createRequest(path: String, queryItems: [URLQueryItem] = []) -> URLRequest? {
        let tokenStorage = OAuth2TokenStorage()
        
        guard let token = tokenStorage.token else {
            print("[UrlRequestConstructor:createRequest]: No token found.")
            return nil
        }
        
        let baseUrl = Constants.defaultBaseURL
        let path = path
        let bearerToken = "Bearer " + token
        
        guard var urlComponents = URLComponents(string: baseUrl) else {
            print("[UrlRequestConstructor:createRequest]: invalid URL")
            return nil
        }
        
        urlComponents.path = path
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            print("Invalid url")
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.setValue(bearerToken, forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = "GET"
        
        return urlRequest
    }
}

