//
//  MockLogoutService.swift
//  ImageFeed
//
//  Created by Rodion Kim on 20/10/2024.
//

import UIKit
import ImageFeed

final class MockLogoutService: ProfileLogoutServiceProtocol {
    var logoutCalled = false
    
    func logout(completion: @escaping () -> Void) {
        logoutCalled = true
        completion()
    }
}
