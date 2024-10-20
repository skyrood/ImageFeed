//
//  PhotoModel.swift
//  ImageFeed
//
//  Created by Rodion Kim on 15/10/2024.
//

import UIKit

public struct Photo {
    public let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let regularImageURL: String
    let largeImageURL: String
    var isLiked: Bool
    
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
