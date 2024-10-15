//
//  ImageListCell.swift
//  ImageFeed
//
//  Created by Rodion Kim on 09/08/2024.
//

import UIKit

protocol ImageListCellDelegate: AnyObject {
    func didTapLikeButton(in cell: ImageListCell)
}

final class ImageListCell: UITableViewCell {
    
    // MARK: - IB Outlets
    @IBOutlet private weak var imageContainer: UIImageView!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var dateLabel: UILabel!

    // MARK: - Public Properties
    static let reuseIdentifier = "ImageListCell"
    var likeButtonAction: (() -> Void)?

    // MARK: - Private Properties
    private weak var delegate: ImageListCellDelegate?

    // MARK: - IB Actions
    @IBAction private func likeButtonTapped(_ sender: UIButton) {
        delegate?.didTapLikeButton(in: self)
    }

    // MARK: - Public Methods
    func configure(with photo: Photo, delegate: ImageListCellDelegate) {
        self.imageContainer.layer.cornerRadius = 16
        self.imageContainer.layer.masksToBounds = true
        
        self.delegate = delegate
        
        self.imageContainer.kf.setImage(with: URL(string: photo.regularImageURL))
        
        self.dateLabel.text = photo.createdAt?.dateTimeString
    }
    
    func updateLikeButtonImage(with status: Bool) {
        DispatchQueue.main.async {
            self.likeButton.setBackgroundImage(status ? UIImage(named: "LikeButtonOn") : UIImage(named: "LikeButtonOff"), for: .normal)
        }
    }
}
