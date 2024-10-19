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
    let large: String
}

final class ProfileImageService {
    
    // MARK: - Public Properties
    static let shared = ProfileImageService()
    
    var requestConstructor: URLRequestConstructorProtocol
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")

    // MARK: - Private Properties
    private var task: URLSessionTask?
    
    private(set) var userPicURL: String?

    // MARK: - Initializers
    private init() {
        requestConstructor = URLRequestConstructor()
    }

    // MARK: - Public Methods
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
                
        guard let userPicURLRequest = requestConstructor.createRequest(path: "/users/\(username)", queryItems: []) else { return }
        
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
                                        userInfo: [:])
        
        self.task = task
        task.resume()
    }
    
    func cleanProfileImage() {
        self.userPicURL = nil
    }
}
