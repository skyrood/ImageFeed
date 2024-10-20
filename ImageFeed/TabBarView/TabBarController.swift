//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Rodion Kim on 27/09/2024.
//

import UIKit

final class TabBarController: UITabBarController {
    
    // MARK: - Override methods
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let imageListViewController = storyboard.instantiateViewController(withIdentifier: "ImageListViewController")
        guard let imageListViewController = imageListViewController as? ImageListViewController else { return }
        let imageListPresenter = ImageListPresenter(imageListService: ImageListService.shared)

        imageListViewController.presenter = imageListPresenter
        imageListPresenter.view = imageListViewController
        
        let profileViewController = ProfileViewController()
        let profilePresenter = ProfilePresenter(profileService: ProfileService.shared,
                                                profileLogoutService: ProfileLogoutService.shared,
                                                profileImageService: ProfileImageService.shared)
        
        profilePresenter.view = profileViewController
        profileViewController.presenter = profilePresenter
        profileViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "tab_profile_active"), selectedImage: nil)
        
        self.viewControllers = [imageListViewController, profileViewController]
    }
}
