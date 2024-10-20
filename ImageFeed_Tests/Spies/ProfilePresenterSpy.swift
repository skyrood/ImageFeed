//
//  ProfilePresenterSpy.swift
//  ImageFeed
//
//  Created by Rodion Kim on 19/10/2024.
//

import UIKit
import ImageFeed

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var view: ProfileViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func avatarURL() -> URL? {
        return nil
    }
    
    func profileDetails() -> ProfileDetails? {
        return nil
    }
    
    func logout() {
        
    }
}
