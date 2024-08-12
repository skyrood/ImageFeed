//
//  ImageListCell.swift
//  ImageFeed
//
//  Created by Rodion Kim on 09/08/2024.
//

import UIKit

final class ImageListCell: UITableViewCell {
    static let reuseIdentifier = "ImageListCell"
    
    @IBOutlet weak var imageContainer: UIImageView!
    @IBOutlet weak var backgroundLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
}
