//
//  MockProvileViewController.swift
//  ImageFeed
//
//  Created by Rodion Kim on 20/10/2024.
//

import UIKit
import ImageFeed

class MockProfileViewController: ProfileViewControllerProtocol {
    var presenter: (any ImageFeed.ProfileViewPresenterProtocol)?
    
    var nameLabel: UILabel = UILabel()
    
    var usernameLabel: UILabel = UILabel()
    
    var statusMessageLabel: UILabel = UILabel()
    
    var profileImageView: UIImageView = UIImageView()
    
    var navigateCalled = false
    var destinationVC: UIViewController?
    
    func updateAvatar() { }
    
    func navigate(to viewController: UIViewController) {
        navigateCalled = true
        destinationVC = viewController
    }
}
