//
//  ImageListService.swift
//  ImageFeed
//
//  Created by Rodion Kim on 05/10/2024.
//

import UIKit

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let regularImageURL: String
    let largeImageURL: String
    let isLiked: Bool
    
    init(from result: PhotoResult) {
        self.id = result.id
        self.size = CGSize(width: result.width, height: result.height)
        self.createdAt = result.createdAt?.toDate()
        self.welcomeDescription = result.description ?? ""
        self.regularImageURL = result.urls.regular
        self.largeImageURL = result.urls.full
        self.isLiked = result.isLiked
    }
}

struct PhotoResult: Decodable {
    let id: String
    let width: Int
    let height: Int
    let createdAt: String?
    let description: String?
    let urls: UrlsResult
    let isLiked: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case width
        case height
        case createdAt = "created_at"
        case description
        case urls
        case isLiked = "liked_by_user"
    }
}

struct UrlsResult: Decodable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}

final class ImageListService {
    static let shared = ImageListService()
    
    private init() {}
    
    private(set) var photos: [Photo] = []
    
    private var task: URLSessionTask?
    
    private var lastLoadedPage: Int?
    
    private var imagesPerPage = 10
    
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    func fetchPhotosNextPage(_ token: String, _ completion: @escaping (Result<[Photo], Error>) -> Void) {
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        let path = "/photos"
        
        let queryItems = [
            URLQueryItem(name: "page", value: String(nextPage)),
            URLQueryItem(name: "per_page", value: String(imagesPerPage))
        ]
        
        guard let imageListRequest = UrlRequestConstructor.createRequest(path: path, token: token, queryItems: queryItems) else { return }
        
        if self.task != nil {
            self.task?.cancel()
        }
        
        let task = URLSession.shared.objectTask(for: imageListRequest) { [weak self] (result: Result<[PhotoResult], Error>) in
            switch result {
            case .success(let responseData):
                
                for image in responseData {
                    let photo = Photo(from: image)
                    
                    self?.photos.append(photo)
                }
                
                NotificationCenter.default.post(name: ImageListService.didChangeNotification, object: self)
                
                guard
                    let photos = self?.photos,
                    !photos.isEmpty
                else { return }
                
                completion(.success(photos))
                
            case .failure(let error):
                print("[ImageListService.fetchPhotosNextPage]: Network error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        lastLoadedPage = nextPage
        
        self.task = task
        task.resume()
    }
}
