//
//  MockImageListCell.swift
//  ImageFeed
//
//  Created by Rodion Kim on 20/10/2024.
//

import UIKit
@testable import ImageFeed

class MockImageListCell: ImageListCell {
    var photoId: String?
    var isLiked: Bool = false
    var descriptionLabel: UILabel = UILabel()

    override func configure(with photo: Photo, delegate: ImageListCellDelegate?) {
        self.photoId = photo.id
        self.isLiked = photo.isLiked
        self.descriptionLabel.text = photo.welcomeDescription
    }

    override func updateLikeButtonImage(with isLiked: Bool) {
        self.isLiked = isLiked
    }
}
