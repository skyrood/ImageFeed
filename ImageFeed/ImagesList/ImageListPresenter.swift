//
//  ImageListViewPresenter.swift
//  ImageFeed
//
//  Created by Rodion Kim on 20/10/2024.
//

import UIKit

public protocol ImageListPresenterProtocol {
    var view: ImageListViewControllerProtocol? { get set }
    
    func loadPhotos()
    func loadNextPhotos(forRowAt indexPath: IndexPath)
    func photosCount() -> Int
    func prepareCell(_ tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell
    func prepareForSingleImageSegue(at indexPath: IndexPath) -> Photo?
    func getNewIndexPaths() -> [IndexPath]
    func calculateImageHeight(for indexPath: IndexPath, tableViewWidth: CGFloat) -> CGFloat
}

final class ImageListPresenter: ImageListPresenterProtocol {

    // MARK: - Public Properties
    var view: ImageListViewControllerProtocol?
    
    var imageListService: ImageListServiceProtocol
    
    // MARK: - Private Properties
    private var photos: [Photo] = []
    
    // MARK: - Initializers
    init(imageListService: ImageListServiceProtocol) {
        self.imageListService = imageListService
    }
    
    // MARK: - Public Methods
    func loadPhotos() {
        print("loading photos...")
        imageListService.fetchPhotosNextPage() { [weak self] result in
            switch result {
            case .success:
                print("success photos loaded")
                self?.view?.updateTableViewAnimated()
            case .failure(let error):
                print("ImageListViewController.loadPhotos]: Failed to fetch photos. Error occurred: \(error.localizedDescription)")
                break
            }
        }
    }
    
    func loadNextPhotos(forRowAt indexPath: IndexPath) {
        if indexPath.row == imageListService.photos.count - 1 {
            self.loadPhotos()
        }
    }
    
    func photosCount() -> Int {
        return imageListService.photos.count
    }
    
    func prepareCell(_ tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImageListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImageListCell else {
            print("creating ImageListCell failed")
            return UITableViewCell()
        }
        
        let photo = imageListService.photos[indexPath.row]
        imageListCell.configure(with: photo, delegate: self)
        imageListCell.updateLikeButtonImage(with: photo.isLiked)
        
        return imageListCell
    }
    
    func prepareForSingleImageSegue(at indexPath: IndexPath) -> Photo? {
        return imageListService.photos[indexPath.row]
    }
    
    func getNewIndexPaths() -> [IndexPath] {
        let oldCount = photos.count
        let newCount = imageListService.photos.count
        photos = imageListService.photos
        
        guard oldCount != newCount else { return [] }
        
        let indexPaths = (oldCount..<newCount).map { IndexPath(row: $0, section: 0) }
        return indexPaths
    }
        
    func calculateImageHeight(for indexPath: IndexPath, tableViewWidth: CGFloat) -> CGFloat {
        guard let image = image(at: indexPath) else { return 0 }
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageContainerWidth = tableViewWidth - imageInsets.left - imageInsets.right
        let imageContainerHeight = imageContainerWidth * image.size.height / image.size.width + imageInsets.top + imageInsets.bottom
        
        return imageContainerHeight
    }
    
    // MARK: - Private Methods
    private func image(at indexPath: IndexPath) -> Photo? {
        guard indexPath.row < photos.count else { return nil }
        return photos[indexPath.row]
    }
}

// MARK: - ImageListCellDelegate
extension ImageListPresenter: ImageListCellDelegate {
    func didTapLikeButton(in cell: ImageListCell) {
        guard let indexPath = view?.tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        
        UIBlockingProgressHUD.show()
        
        imageListService.changeLike(photo: photo.id, isLike: photo.isLiked) { [weak self] result in
            switch result {
            case .success():
                guard let self else { return }
                photos[indexPath.row].isLiked = !photo.isLiked
                cell.updateLikeButtonImage(with: photos[indexPath.row].isLiked)
            case .failure(let error):
                print("[ImageListViewController.didTapLikeButton] Error: \(error.localizedDescription)")
            }
            
            UIBlockingProgressHUD.dismiss()
        }
    }
}
