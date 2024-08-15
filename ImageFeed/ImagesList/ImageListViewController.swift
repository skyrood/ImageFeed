//
//  ViewController.swift
//  ImageFeed
//
//  Created by Rodion Kim on 08/08/2024.
//

import UIKit

class ImageListViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    
    // changing status bar icons to white because the app background is dark
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private let photosNames: [String] = Array(0..<20).map{ "\($0)" }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting the insets for the table
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
}

extension ImageListViewController: UITableViewDataSource {
    // method for setting the number of cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosNames.count
    }
    
    // method for creating or reusing cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImageListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImageListCell else {
            print("creating ImageListCell failed")
            return UITableViewCell()
        }
        
        imageListCell.imageContainer.layer.cornerRadius = 16
        imageListCell.imageContainer.layer.masksToBounds = true
                
        imageListCell.isUserInteractionEnabled = false
        
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
}

extension ImageListViewController {
    // method for filling custom cells
    func configCell(for cell: ImageListCell, with indexPath: IndexPath) {
        
        let currentIndex = indexPath.row
        
        let imageName = photosNames[currentIndex]
        cell.imageContainer.image = UIImage(named: imageName)
        
        cell.dateLabel.text = formatDate(Date())
                
        if currentIndex % 2 == 0 {
            if let backgroundImage = UIImage(named: "LikeButtonOn") {
                cell.likeButton.setBackgroundImage(backgroundImage, for: .normal)
            }
        } else {
            if let backgroundImage = UIImage(named: "LikeButtonOff") {
                cell.likeButton.setBackgroundImage(backgroundImage, for: .normal)
            }
        }
    }
}

extension ImageListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { }
    
    // method for setting the cell height dynamically
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageName = photosNames[indexPath.row]
        
        guard let image = UIImage(named: imageName) else {
            return 0
        }
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageContainerWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageContainerHeight = imageContainerWidth * image.size.height / image.size.width + imageInsets.top + imageInsets.bottom
        
        return imageContainerHeight
    }
}
