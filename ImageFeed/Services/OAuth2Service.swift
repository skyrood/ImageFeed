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

enum AuthServiceError: Error {
    case invalidRequest
}

final class OAuth2Service {
    
    static let shared = OAuth2Service()
    
    private var task: URLSessionTask?
    private var lastCode: String?
    
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
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if task != nil {
            if lastCode != code {
                task?.cancel()
            } else {
                completion(.failure(AuthServiceError.invalidRequest))
                return
            }
        } else {
            if lastCode == code {
                completion(.failure(AuthServiceError.invalidRequest))
                return
            }
        }
        
        lastCode = code
        
        guard let request = makeOAuthTokenRequest(code: code) else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        let task = URLSession.shared.data(for: request) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    do {
                        let responseData = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                        let accessToken = responseData.accessToken
                        self?.tokenStorage.storeToken(accessToken)
                        completion(.success(accessToken))
                    } catch {
                        print("Failed to decode data. \nError occurred: \(error.localizedDescription)")
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
                
                self?.task = nil
                self?.lastCode = nil
            }
        }
        
        self.task = task
        task.resume()
    }
    
    func isAccessTokenAvailable() -> Bool {
        return tokenStorage.token != nil
    }
}
