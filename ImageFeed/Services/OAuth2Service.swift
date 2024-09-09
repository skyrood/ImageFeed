//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Rodion Kim on 31/08/2024.
//

import UIKit

struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
    
    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}

final class OAuth2Service {
    
    static let shared = OAuth2Service()
    
    private let tokenStorage = OAuth2TokenStorage()
    
    private init() {}
    
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        let baseUrl = "https://unsplash.com"
        let path = "/oauth/token"
        
        guard var urlComponents = URLComponents(string: baseUrl) else {
            print("Invalid base url")
            return nil
        }
        
        urlComponents.path = path
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code"),
        ]
        
        guard let url = urlComponents.url else {
            print("Failed to construct url")
            return nil
        }
                
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        return request
    }
    
    private enum NetworkError: Error {
        case codeError(Int)
    }
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void) {
        guard let request = makeOAuthTokenRequest(code: code) else { return }
        
        let task = URLSession.shared.data(for: request) { result in
            switch result {
            case .success(let data):
                do {
                    let responseData = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                    self.tokenStorage.storeToken(responseData.accessToken)
                                        
                    completion(.success(responseData))
                } catch {
                    print("Failed to decode data")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("Failed to obtain access token")
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func isAccessTokenAvailable() -> Bool {
        return tokenStorage.token != nil
    }
}
