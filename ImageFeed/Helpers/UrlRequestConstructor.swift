//
//  UrlConstructor.swift
//  ImageFeed
//
//  Created by Rodion Kim on 05/10/2024.
//

import Foundation

func urlRequestConstructor(path: String, _ token: String) -> URLRequest? {
    let baseUrl = Constants.defaultBaseURL
    let path = path
    let bearerToken = "Bearer " + token
    
    guard var urlComponents = URLComponents(string: baseUrl) else {
        print("Error: invalid URL")
        return nil
    }
    
    urlComponents.path = path
    
    guard let url = urlComponents.url else {
        print("Invalid url")
        return nil
    }
    
    var urlRequest = URLRequest(url: url)
    
    urlRequest.setValue(bearerToken, forHTTPHeaderField: "Authorization")
    urlRequest.httpMethod = "GET"
    
    return urlRequest
}
