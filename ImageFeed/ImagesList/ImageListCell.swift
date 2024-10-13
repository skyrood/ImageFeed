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
    // setting the cell reuse identifier
    static let reuseIdentifier = "ImageListCell"
    
    weak var delegate: ImageListCellDelegate?
    
    // outlets for cell elements
    @IBOutlet weak var imageContainer: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    var likeButtonAction: (() -> Void)?
    
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        delegate?.didTapLikeButton(in: self)
    }
}
