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
    let lastName: String
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

    private func makeProfileRequest(_ token: String) -> URLRequest? {
        let baseUrl = "https://api.unsplash.com"
        let path = "/me"
        
        let bearerToken = "Bearer " + token
        
        guard var urlComponents = URLComponents(string: baseUrl) else {
            print("Invalid base url")
            return nil
        }
        
        urlComponents.path = path
        
        guard let url = urlComponents.url else {
            print("Invalid url")
            return nil
        }
        
        var profileRequest = URLRequest(url: url)
        
        profileRequest.setValue(bearerToken, forHTTPHeaderField: "Authorization")
        profileRequest.httpMethod = "GET"
        
        return profileRequest
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        if task != nil {
            task?.cancel()
        }
        
        guard let profileRequest = makeProfileRequest(token) else {
            completion(.failure(ProfileServiceError.invalidRequest))
            return
        }
        
        let task = URLSession.shared.data(for: profileRequest) { result in
            switch result {
            case .success(let data):
                do {
                    let responseData = try JSONDecoder().decode(ProfileResult.self, from: data)
                    
                    self.profile = Profile(
                        username: responseData.username,
                        firstName: responseData.firstName,
                        lastName: responseData.lastName,
                        bio: responseData.bio ?? ""
                    )
                    
                    guard let profile = self.profile else {
                        completion(.failure(ProfileServiceError.decodingError))
                        return
                    }
                                        
                    completion(.success(profile))
                } catch {
                    print("Failed to decode data. \nError occurred: \(error.localizedDescription)")
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
