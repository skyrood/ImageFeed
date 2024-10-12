//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Rodion Kim on 19/09/2024.
//

import Foundation

struct ProfileResult: Codable {
    let username: String
    let firstName: String
    let lastName: String?
    let bio: String?
    
    private enum CodingKeys: String, CodingKey {
        case username = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio = "bio"
    }
}

struct Profile {
    var username: String
    var firstName: String
    var lastName: String
    
    var name: String {
        let fullName = "\(firstName) \(lastName)"
        return fullName
    }
    
    var loginName: String {
        let loginName = "@\(username)"
        return loginName
    }
    
    var bio: String
}

enum ProfileServiceError: Error {
    case invalidRequest
    case decodingError
}

final class ProfileService {
    
    static let shared = ProfileService()
    
    private(set) var profile: Profile?
    
    private var task: URLSessionTask?
    
    private init() {}
    
    func fetchProfile(completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        if self.task != nil {
            self.task?.cancel()
        }
        
        guard let profileRequest = UrlRequestConstructor.createRequest(path: "/me") else {
            completion(.failure(ProfileServiceError.invalidRequest))
            return
        }
        
        let task = URLSession.shared.objectTask(for: profileRequest) { [weak self] (result: Result<ProfileResult, Error>) in
            switch result {
            case .success(let responseData):
                self?.profile = Profile(
                    username: responseData.username,
                    firstName: responseData.firstName,
                    lastName: responseData.lastName ?? "",
                    bio: responseData.bio ?? "")
                
                guard let profile = self?.profile else { return }
                completion(.success(profile))
            case .failure(let error):
                print("[ProfileService.fetchProfile]: Network error = \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        
        self.task = task
        task.resume()
    }
}
