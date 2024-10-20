//
//  UrlConstructor.swift
//  ImageFeed
//
//  Created by Rodion Kim on 05/10/2024.
//

import Foundation

protocol AuthHelperProtocol {
    func authRequest() -> URLRequest?
    func code(from url: URL) -> String?
}

protocol URLRequestConstructorProtocol {
    func createRequest(path: String, queryItems: [URLQueryItem]) -> URLRequest?
}

final class URLRequestConstructor: URLRequestConstructorProtocol, AuthHelperProtocol {
    
    let configuration: AuthConfiguration
    
    init(configuration: AuthConfiguration = .secondary) {
        self.configuration = configuration
    }
    
    func createRequest(path: String, queryItems: [URLQueryItem] = []) -> URLRequest? {
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
    
    func authRequest() -> URLRequest? {
        guard let url = authURL() else { return nil }
        
        return URLRequest(url: url)
    }
    
    func authURL() -> URL? {
        guard var urlComponents = URLComponents(string: configuration.unsplashAuthorizeURLString) else {
            print("error while creating urlComponents")
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: configuration.accessKey),
            URLQueryItem(name: "redirect_uri", value: configuration.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: configuration.accessScope),
        ]
        
        return urlComponents.url
    }
    
    func code(from url: URL) -> String? {
        if
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
}

