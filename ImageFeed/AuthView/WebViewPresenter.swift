//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Rodion Kim on 18/10/2024.
//

import UIKit

public protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
}

final class WebViewPresenter: WebViewPresenterProtocol {
    
    // MARK: - IB Outlets

    // MARK: - Public Properties
    weak var view: WebViewViewControllerProtocol?
    
    var authHelper: AuthHelperProtocol

    // MARK: - Private Properties
    private let authConfig = AuthConfiguration.main

    // MARK: - Initializers
    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
    }

    // MARK: - Overrides Methods

    // MARK: - IB Actions

    // MARK: - Public Methods
    func viewDidLoad() {
//        guard var urlComponents = URLComponents(string: authConfig.unsplashAuthorizeURLString) else {
//            print("error while creating urlComponents")
//            return
//        }
//        
//        urlComponents.queryItems = [
//            URLQueryItem(name: "client_id", value: Constants.accessKey),
//            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
//            URLQueryItem(name: "response_type", value: "code"),
//            URLQueryItem(name: "scope", value: Constants.accessScope),
//        ]
//        
//        guard let url = urlComponents.url else {
//            print("Error while creating url from urlComponents")
//            return
//        }
//        
//        let request = URLRequest(url: url)
        guard let request = authHelper.authRequest() else { return }
        view?.load(request)
        
        didUpdateProgressValue(0)
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
            let newProgressValue = Float(newValue)
            view?.setProgressValue(newProgressValue)
            
            let shouldHideProgress = shouldHideProgress(for: newProgressValue)
            view?.setProgressHidden(shouldHideProgress)
        }
        
        func shouldHideProgress(for value: Float) -> Bool {
            abs(value - 1.0) <= 0.0001
        }
    
    func code(from url: URL) -> String? {
        authHelper.code(from: url)
    }

    // MARK: - Private Methods

}
