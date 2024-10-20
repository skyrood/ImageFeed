//
//  ProfileViewTests.swift
//  ImageFeed
//
//  Created by Rodion Kim on 19/10/2024.
//

import XCTest
@testable import ImageFeed

final class ProfileViewTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testProfileDetailsNotNil() {
        //given
        let firstName = "Mark"
        let lastName = "Zuckerberg"
        let username = "zucker_sweet"
        let bio = "I'm the master of the world"
        
        let expectedName = "\(firstName) \(lastName)"
        let expectedUsername = "@\(username)"
        let expectedBio = bio
        
        let mockProfileService = MockProfileService()
        let mockProfileImageService = MockProfileImageService()
        let mockLogoutService = MockLogoutService()
        
        let presenter = ProfilePresenter(profileService: mockProfileService,
                                         profileLogoutService: mockLogoutService,
                                         profileImageService: mockProfileImageService)
        
        presenter.profileService = mockProfileService
        
        //when
        let mockProfile = Profile(username: username, firstName: firstName, lastName: lastName, bio: bio)
        mockProfileService.profile = mockProfile
        
        let profileDetails = presenter.profileDetails()
        
        //then
        XCTAssertNotNil(profileDetails)
        XCTAssertEqual(profileDetails?.name, expectedName)
        XCTAssertEqual(profileDetails?.username, expectedUsername)
        XCTAssertEqual(profileDetails?.bio, expectedBio)
    }
    
    func testLogoutCallsLogoutServiceAndNavigatesToSplash() {
        //given
        let mockView = MockProfileViewController()
        
        let mockProfileService = MockProfileService()
        let mockProfileImageService = MockProfileImageService()
        let mockLogoutService = MockLogoutService()
        
        let presenter = ProfilePresenter(profileService: mockProfileService,
                                         profileLogoutService: mockLogoutService,
                                         profileImageService: mockProfileImageService)
        presenter.view = mockView
        
        //when
        presenter.logout()
        
        //then
        XCTAssertTrue(mockLogoutService.logoutCalled)
        XCTAssertTrue(mockView.navigateCalled)
        XCTAssertNotNil(mockView.destinationVC)
        XCTAssertTrue(mockView.destinationVC is SplashViewController)
    }
    
    func testAvatarURLReturnsCorrectURL() {
        //given
        let mockProfileService = MockProfileService()
        let mockProfileImageService = MockProfileImageService()
        let mockLogoutService = MockLogoutService()
        
        let presenter = ProfilePresenter(profileService: mockProfileService,
                                         profileLogoutService: mockLogoutService,
                                         profileImageService: mockProfileImageService)
        
        //when
        let avatarURL = presenter.avatarURL()
        
        //then
        XCTAssertNotNil(avatarURL)
        XCTAssertEqual(avatarURL?.absoluteString, "https://unsplash.com/i-want-my-avatar.jpg")
    }
    
    func testAvatarURLReturnsNilWhenNoURL() {
        //given
        let mockProfileService = MockProfileService()
        let mockProfileImageService = MockProfileImageService()
        let mockLogoutService = MockLogoutService()
        
        let presenter = ProfilePresenter(profileService: mockProfileService,
                                         profileLogoutService: mockLogoutService,
                                         profileImageService: mockProfileImageService)
        
        mockProfileImageService.userPicURL = nil
        
        //when
        let avatarURL = presenter.avatarURL()
        
        //then
        XCTAssertNil(avatarURL)
    }
}
