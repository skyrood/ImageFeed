//
//  ImageFeed_Tests.swift
//  ImageFeed_Tests
//
//  Created by Rodion Kim on 19/10/2024.
//

import XCTest
@testable import ImageFeed

final class WebViewTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        //given
        let viewController = WebViewViewController()
        let presenter = WebViewPresenterSpy()
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsLoadRequest() {
        //given
        let viewController = WebViewViewControllerSpy()
        let authHelper = UrlRequestConstructor()
        let presenter = WebViewPresenter(authHelper: authHelper)
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        presenter.viewDidLoad()
        
        //then
        XCTAssertTrue(viewController.loadRequestCalled)
    }
    
    func testProgressVisibleWhenLessThenOne() {
        //given
        let authHepler = UrlRequestConstructor()
        let presenter = WebViewPresenter(authHelper: authHepler)
        let progress: Float = 0.666
        
        //when
        let shouldHideProgressBar = presenter.shouldHideProgress(for: progress)
        
        //then
        XCTAssertFalse(shouldHideProgressBar)
    }
    
    func testProgressHiddenWhenOne() {
        //given
        let authHepler = UrlRequestConstructor()
        let presenter = WebViewPresenter(authHelper: authHepler)
        let progress: Float = 1
        
        //when
        let shouldHideProgressBar = presenter.shouldHideProgress(for: progress)
        
        //then
        XCTAssertTrue(shouldHideProgressBar)
    }
}
