//
//  Constants.swift
//  ImageFeed
//
//  Created by Rodion Kim on 28/08/2024.
//

import Foundation

enum Constants {
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com/")
}
