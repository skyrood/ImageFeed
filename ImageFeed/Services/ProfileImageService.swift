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
    let medium: String
    let large: String
}

final class ProfileImageService {
    static let shared = ProfileImageService()
    
    private init() {}
    
    private var task: URLSessionTask?
    
    private(set) var userPicURL: String?
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
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
        
        let task = URLSession.shared.objectTask(for: userPicURLRequest) { [weak self] (result: Result<UserResult, Error>) in
            switch result {
            case .success(let responseData):
                self?.userPicURL = responseData.profileImage.large
                
                guard let userPicURL = self?.userPicURL else { return }
                completion(.success(userPicURL))
                
            case .failure(let error):
                print("[ProfileImageService.fetchProfileImageURL]: Network error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        
        NotificationCenter.default.post(name: ProfileImageService.didChangeNotification,
                                        object: self,
                                        userInfo: ["URL": self.userPicURL])
        
        self.task = task
        task.resume()
    }
}
