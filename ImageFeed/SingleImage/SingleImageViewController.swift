//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Rodion Kim on 15/08/2024.
//

import UIKit
import ProgressHUD
import Kingfisher

final class SingleImageViewController: UIViewController {
    
    // MARK: - IB Outlets
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var singleImageScrollView: UIScrollView!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private weak var shareButton: UIButton!

    // MARK: - Private Properties
    private var image: Photo? {
        didSet {
            UIBlockingProgressHUD.show()
            
            guard isViewLoaded, let image else { return }
            
            imageView.kf.setImage(with: URL(string: image.largeImageURL)) { _ in
                UIBlockingProgressHUD.dismiss()
            }
            
            imageView.frame.size = image.size
            rescaleAndCenterImageInScrollView(image: image)
        }
    }

    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        singleImageScrollView.minimumZoomScale = 0.1
        singleImageScrollView.maximumZoomScale = 1.25
        
        guard let image else { return }
        imageView.kf.setImage(with: URL(string: image.largeImageURL)) { _ in
            UIBlockingProgressHUD.dismiss()
        }
        
        imageView.frame.size = image.size
        rescaleAndCenterImageInScrollView(image: image)
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        let backButtonImage = UIImage(named: "BackButton")
        
        NSLayoutConstraint.activate([
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44),
            backButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: -1),
            backButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 1)
        ])
        
        if #available(iOS 15.0, *) {
            var imageConfig = UIButton.Configuration.plain()
            imageConfig.image = backButtonImage
            imageConfig.imagePadding = 10
            backButton.configuration = imageConfig
        } else {
            backButton.setBackgroundImage(backButtonImage, for: .normal)
            backButton.imageView?.contentMode = .center
            backButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
    }

    // MARK: - IB Actions
    @IBAction private func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func didTapShareButton(_ sender: Any) {
        guard let image else { return }
        let shareView = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(shareView, animated: true, completion: nil)
    }

    // MARK: - Public Methods
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateScrollViewInsets()
    }
    
    func setImage(with photo: Photo) {
        self.image = photo
    }

    // MARK: - Private Methods
    private func rescaleAndCenterImageInScrollView(image: Photo) {
        let minZoomScale = singleImageScrollView.minimumZoomScale
        let maxZoomScale = singleImageScrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = singleImageScrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
        singleImageScrollView.setZoomScale(scale, animated: false)
        singleImageScrollView.layoutIfNeeded()
        let newContentSize = singleImageScrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        singleImageScrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    private func updateScrollViewInsets() {
        let visibleRectSize = singleImageScrollView.bounds.size
        let newContentSize = singleImageScrollView.contentSize
        let x = max(0, (visibleRectSize.width - newContentSize.width) / 2)
        let y = max(0, (visibleRectSize.height - newContentSize.height) / 2)

        singleImageScrollView.contentInset = UIEdgeInsets(top: y, left: x, bottom: y, right: x)
    }
}

// MARK: - UIScrollViewDelegate
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
