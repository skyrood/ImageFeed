//
//  ProfileModel.swift
//  ImageFeed
//
//  Created by Rodion Kim on 15/10/2024.
//

import UIKit

public struct Profile {
    var username: String
    var firstName: String
    var lastName: String
    
    var name: String {
        let fullName = "\(firstName) \(lastName)"
        return fullName
    }
    
    var loginName: String {
        let loginName = "@\(username)"
        return loginName
    }
    
    var bio: String
}
