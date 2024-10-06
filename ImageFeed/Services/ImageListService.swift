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
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}

struct PhotoResult: Decodable {
    let id: String
    let width: Int
    let height: Int
    let createdAt: String
    let description: String
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
    
    private var imagesPerPage = 2
    
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    func fetchPhotosNextPage(_ token: String, _ completion: @escaping (Result<[Photo], Error>) -> Void) {
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        let path = "/photos?per_page=\(imagesPerPage)&page=\(nextPage)"
        
        guard let imageListRequest = urlRequestConstructor(path: path, token) else { return }
        
        if self.task != nil {
            self.task?.cancel()
        }
        
        let task = URLSession.shared.objectTask(for: imageListRequest) { [weak self] (result: Result<[PhotoResult], Error>) in
            switch result {
            case .success(let responseData):
                
                for image in responseData {
                    let photo = Photo(id: image.id,
                                      size: CGSize(width: image.width, height: image.height),
                                      createdAt: image.createdAt.toDate(),
                                      welcomeDescription: image.description ?? "",
                                      thumbImageURL: image.urls.thumb,
                                      largeImageURL: image.urls.full,
                                      isLiked: image.isLiked)
                    
                    self?.photos.append(photo)
                }
                
                NotificationCenter.default.post(name: ImageListService.didChangeNotification,
                                                object: self,
                                                userInfo: ["URL": "omg.wtf"]) // TODO: decide what to pass here
                
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
    }
}
