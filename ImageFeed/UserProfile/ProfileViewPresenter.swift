//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Rodion Kim on 19/10/2024.
//

import UIKit

protocol ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    
    func avatarURL() -> URL?
    func profileDetails() -> ProfileDetails?
    func viewDidLoad()
    func logout()
}

struct ProfileDetails {
    let name: String
    let username: String
    let bio: String
    
    init(name: String, username: String, bio: String) {
        self.name = name
        self.username = username
        self.bio = bio
    }
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    
    // MARK: - Public Properties
    weak var view: ProfileViewControllerProtocol?
    
    let profileService = ProfileService.shared
    
    let profileImageService = ProfileImageService.shared
    let profileLogoutService = ProfileLogoutService.shared
    
    // MARK: - Private Properties
    private var profileImageServiceObserver: NSObjectProtocol?
    
    // MARK: - Public Methods
    func profileDetails() -> ProfileDetails? {
        guard let profile = profileService.profile else {
            print("no details found?")
            return nil }
        
        return ProfileDetails(name: profile.name, username: profile.loginName, bio: profile.bio)
    }
    
    func avatarURL() -> URL? {
        guard
            let profileImageURL = profileImageService.userPicURL,
            let url = URL(string: profileImageURL)
        else { return nil }
        
        return url
    }
    
    func viewDidLoad() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(forName: ProfileImageService.didChangeNotification,
                                                                             object: nil,
                                                                             queue: .main) { [weak self] _ in
            guard let self = self else {
                return
            }
            
            view?.updateAvatar()
        }
    }
    
    func logout() {
        profileLogoutService.logout() { [weak self] in
            print("logged out successfully")
            let splashViewController = SplashViewController()
            splashViewController.modalPresentationStyle = .fullScreen
            
            self?.view?.navigate(to: splashViewController)
        }
    }
}
