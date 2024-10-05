//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Rodion Kim on 09/09/2024.
//

import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    private let ShowAuthViewSegueIdentifier = "ShowAuthView"
    
    private let oauth2Service = OAuth2Service.shared
    private let tokenStorage = OAuth2TokenStorage()
    
    let profileService = ProfileService.shared
    
    let profileImageService = ProfileImageService.shared
    
    private var isAuthorizing: Bool = false
    
    private lazy var logoImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.image = UIImage(named: "YP Logo")
        
        return view
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
                
        if let token = tokenStorage.token {
            fetchProfile(token)
        } else if !isAuthorizing {
            isAuthorizing = true
            navigateToAuthviewController()
        }
        
        self.view.backgroundColor = UIColor(named: "YP Black")
        self.view.addSubview(logoImageView)
        setConstraints(for: logoImageView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private func navigateToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid configuration") }
        let tabBarView = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarView
    }
    
    private func navigateToAuthviewController() {
        let authViewController = AuthViewController()
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: true, completion: nil)
    }
    
    private func setConstraints(for logoImageView: UIImageView) {
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 75),
        ])
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWith code: String) {
        self.fetchOAuthToken(vc, code)
    }
    
    func didAuthenticate(_ vc: AuthViewController, token: String) {
        vc.dismiss(animated: true) { [weak self] in
            guard let self else { return }
            
            print("authviewcontroller dismissed?")
            
            guard let token = self.tokenStorage.token else {
                print("no token found.")
                return
            }
            
            fetchProfile(token)
        }
    }
    
    private func fetchOAuthToken(_ vc: AuthViewController, _ code: String) {
        oauth2Service.fetchOAuthToken(code: code) { [ weak self ] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let token):
                didAuthenticate(vc, token: token)
            case .failure:
                showAlert()
            }
        }
    }
    
    private func fetchProfile(_ token: String) {
        UIBlockingProgressHUD.show()
        
        profileService.fetchProfile(token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }
            
            switch result {
            case .success(let profile):
                self.profileImageService.fetchProfileImageURL(username: profile.username, token: token) { _ in }
                self.navigateToTabBarController()
            case .failure(let error):
                print("[SplashViewController.fetchProfile]: Failed to obtain user profile. Error occurred: \(error.localizedDescription)")
                break
            }
        }
    }
    
    private func showAlert() {
        let alertController = UIAlertController(title: "Что-то пошло не так(",
                                                message: "Не удалось войти в систему",
                                                preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(dismissAction)
        
        if var topController = UIApplication.shared.windows.first?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            topController.present(alertController, animated: true, completion: nil)
        }
    }
}
