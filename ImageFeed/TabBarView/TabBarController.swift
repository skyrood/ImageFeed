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
        
        let profileViewController = ProfileViewController()
        let profileViewPresenter = ProfileViewPresenter(profileService: ProfileService.shared,
                                                        profileLogoutService: ProfileLogoutService.shared,
                                                        profileImageService: ProfileImageService.shared)
        
        profileViewPresenter.view = profileViewController
        profileViewController.presenter = profileViewPresenter
        profileViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "tab_profile_active"), selectedImage: nil)
        
        self.viewControllers = [imageListViewController, profileViewController]
    }
}
