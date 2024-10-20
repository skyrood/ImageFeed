//
//  ImageListServiceMock.swift
//  ImageFeed
//
//  Created by Rodion Kim on 20/10/2024.
//

import ImageFeed
import UIKit

final class ImageListServiceMock: ImageListServiceProtocol {
    var photos: [Photo] = []
    
    var didCallFetchPhotosNextPage = false
    
    var didTriggerChangeLike = false
    
    func fetchPhotosNextPage(_ completion: @escaping (Result<[ImageFeed.Photo], any Error>) -> Void) {
        didCallFetchPhotosNextPage = true
        completion(.success(photos))
    }
    
    func changeLike(photo id: String, isLike: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        didTriggerChangeLike = true
    }
}
