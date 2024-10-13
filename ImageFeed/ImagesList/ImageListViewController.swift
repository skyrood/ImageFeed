//
//  ViewController.swift
//  ImageFeed
//
//  Created by Rodion Kim on 08/08/2024.
//

import UIKit
import Kingfisher

final class ImageListViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    
    private var imageListService = ImageListService.shared
            
    private var photos: [Photo] = []
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    // changing status bar icons to white because the app background is dark
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting the insets for the table
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        self.loadPhotos()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }
             
            viewController.image = imageListService.photos[indexPath.row]
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension ImageListViewController: UITableViewDataSource {
    // method for setting the number of cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageListService.photos.count
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

        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == imageListService.photos.count - 1 {
            self.loadPhotos()
        }
    }
}

extension ImageListViewController {
    // method for filling custom cells
    func configCell(for cell: ImageListCell, with indexPath: IndexPath) {
        var cellImage = imageListService.photos[indexPath.row]
        cell.imageContainer.kf.setImage(with: URL(string: cellImage.regularImageURL))
        
        cell.dateLabel.text = cellImage.createdAt?.dateTimeString
        
        updateLikeButtonImage(for: cell, with: !cellImage.isLiked)

        cell.likeButtonAction = { [weak self] in
            self?.imageListService.changeLike(photo: cellImage.id, isLike: cellImage.isLiked) { [weak self] result in
                switch result {
                case .success():
                    guard let self else { return }
                    cellImage.isLiked = !cellImage.isLiked
                    self.updateLikeButtonImage(for: cell, with: !cellImage.isLiked)
                case .failure(let error):
                    print("[ImageListViewController.likeButtonTapped] Error occurred: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imageListService.photos.count
        photos = imageListService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
    
    private func loadPhotos() {
        imageListService.fetchPhotosNextPage() { [weak self] result in
            switch result {
            case .success:
                self?.updateTableViewAnimated()
            case .failure(let error):
                print("ImageListViewController.loadPhotos]: Failed to fetch photos. Error occurred: \(error.localizedDescription)")
                break
            }
        }
    }
    
    private func updateLikeButtonImage(for cell: ImageListCell, with status: Bool) {
        cell.likeButton.setBackgroundImage(status ? UIImage(named: "LikeButtonOff") : UIImage(named: "LikeButtonOn"), for: .normal)
    }
}

extension ImageListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
//     method for setting the cell height dynamically
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let image = imageListService.photos[indexPath.row]
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageContainerWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageContainerHeight = imageContainerWidth * image.size.height / image.size.width + imageInsets.top + imageInsets.bottom
        
        return imageContainerHeight
    }
}
