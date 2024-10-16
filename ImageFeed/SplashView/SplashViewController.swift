//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Rodion Kim on 09/09/2024.
//

import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {

    // MARK: - Public Properties
    let profileService = ProfileService.shared
    
    let profileImageService = ProfileImageService.shared

    // MARK: - Private Properties
    private let ShowAuthViewSegueIdentifier = "ShowAuthView"
    
    private let oauth2Service = OAuth2Service.shared
    private let tokenStorage = OAuth2TokenStorage()
    
    private var isAuthorizing: Bool = false
    
    private lazy var logoImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.image = UIImage(named: "YP Logo")
        
        return view
    }()

    // MARK: - Overrides Methods
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
                
        if tokenStorage.token != nil {
            fetchProfile()
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

    // MARK: - Private Methods
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

// MARK: - AuthViewControllerDelegate
extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWith code: String) {
        oauth2Service.fetchOAuthToken(code: code) { [ weak self ] result in
            guard let self = self else { return }
            
            switch result {
            case .success(_):
                vc.dismiss(animated: true)
            case .failure:
                showAlert()
            }
        }
    }
    
    private func fetchProfile() {
        UIBlockingProgressHUD.show()
        
        profileService.fetchProfile() { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }
            
            switch result {
            case .success(let profile):
                self.profileImageService.fetchProfileImageURL(username: profile.username) { _ in }
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
