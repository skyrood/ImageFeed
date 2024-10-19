//
//  UrlRequestConstructorTests.swift
//  ImageFeed
//
//  Created by Rodion Kim on 19/10/2024.
//

import XCTest
@testable import ImageFeed

final class UrlRequestConstructorTests: XCTestCase {
    func testUrlRequestConstructorAuthUrl() {
        //given
        let configuration = AuthConfiguration.main
        let authHelper = UrlRequestConstructor(configuration: configuration)
        
        //when
        let url = authHelper.authURL()
        
        guard let urlString = url?.absoluteString else {
            XCTFail("Auth URL is nil")
            return
        }
        
        XCTAssertTrue(urlString.contains(configuration.unsplashAuthorizeURLString))
        XCTAssertTrue(urlString.contains(configuration.accessKey))
        XCTAssertTrue(urlString.contains(configuration.redirectURI))
        XCTAssertTrue(urlString.contains(configuration.accessScope))
        XCTAssertTrue(urlString.contains("code"))
    }
    
    func testCodeFromURL() {
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize/native")!
        let queryItems = [
            URLQueryItem(name: "code", value: "test_code")
        ]
        
        urlComponents.queryItems = queryItems
        
        let code = UrlRequestConstructor().code(from: urlComponents.url!)
        
        XCTAssertEqual(code, "test_code")
    }
}
