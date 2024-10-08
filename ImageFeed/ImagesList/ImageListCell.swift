//
//  ImageListCell.swift
//  ImageFeed
//
//  Created by Rodion Kim on 09/08/2024.
//

import UIKit

final class ImageListCell: UITableViewCell {
    // setting the cell reuse identifier
    static let reuseIdentifier = "ImageListCell"
    
    // outlets for cell elements
    @IBOutlet weak var imageContainer: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
}
