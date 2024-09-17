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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = tokenStorage.token {
            navigateToTabBarController()
        } else {
            performSegue(withIdentifier: ShowAuthViewSegueIdentifier, sender: nil)
        }
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
}

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowAuthViewSegueIdentifier {
            guard let authViewController = segue.destination as? AuthViewController else {
                fatalError("Failed to prepare for \(ShowAuthViewSegueIdentifier)")
            }
            authViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWith code: String) {
        dismiss(animated: true) { [ weak self ] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        UIBlockingProgressHUD.show()
        
        oauth2Service.fetchOAuthToken(code: code) { [ weak self ] result in
            guard let self = self else { return }
            
            UIBlockingProgressHUD.dismiss()
            
            switch result {
            case .success:
                self.navigateToTabBarController()
            case .failure:
                break
            }
        }
    }
}
