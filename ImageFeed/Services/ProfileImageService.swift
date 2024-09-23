//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Rodion Kim on 22/09/2024.
//

import Foundation

struct UserResult: Codable {
    let profileImage: image
    
    private enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

struct image: Codable {
    let small: String
}

final class ProfileImageService {
    static let shared = ProfileImageService()
    
    private init() {}
    
    private var task: URLSessionTask?
    
    private(set) var userPicURL: String?
    
    func fetchProfileImageURL(username: String, token: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        let baseUrl = "https://api.unsplash.com"
        let path = "/users/" + username
        
        let bearerToken = "Bearer " + token
        
        guard var urlComponents = URLComponents(string: baseUrl) else {
            print("Invalid base url")
            return
        }
        
        urlComponents.path = path
        
        guard let url = urlComponents.url else {
            print("Invalid url")
            return
        }

        var userPicURLRequest = URLRequest(url: url)
        
        userPicURLRequest.setValue(bearerToken, forHTTPHeaderField: "Authorization")
        userPicURLRequest.httpMethod = "GET"
        
        if self.task != nil {
            self.task?.cancel()
        }
        
        let task = URLSession.shared.data(for: userPicURLRequest) { result in
            switch result {
            case .success(let data):
                do {
                    let responseData = try JSONDecoder().decode(UserResult.self, from: data)
                    
                    self.userPicURL = responseData.profileImage.small
                } catch {
                    print("Failed to decode userPic URL. \nError occurred: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            case .failure(let error):
                networkErrorLogger(error)
                completion(.failure(error))
            }
        }
        
        self.task = task
        task.resume()
    }
}
