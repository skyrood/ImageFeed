//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Rodion Kim on 29/08/2024.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWith code: String)
}

final class AuthViewController: UIViewController {

    // MARK: - Public Properties
    weak var delegate: AuthViewControllerDelegate?

    // MARK: - Private Properties
    private lazy var logoView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        guard let image = UIImage(named: "unsplashLogo") else { return UIImageView() }
        view.image = image
        
        return view
    }()
    
    private lazy var signinButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.clipsToBounds = true
        button.layer.cornerRadius = 16
        
        button.setTitle("Войти", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.setTitleColor(UIColor(named: "YP Black") ?? UIColor.black, for: .normal)
        
        button.backgroundColor = UIColor(named: "YP White") ?? UIColor.white
        
        button.addTarget(self, action: #selector(signinButtonTapped), for: .touchUpInside)
        
        return button
    }()

    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(named: "YP Black")
        self.view.addSubview(logoView)
        self.view.addSubview(signinButton)
        
        setConstraints(for: logoView)
        setConstraints(for: signinButton)
    }

    // MARK: - Private Methods
    @objc private func signinButtonTapped() {
        navigateToWebView()
    }
    
    private func setConstraints(for imageView: UIImageView) {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 60),
            imageView.heightAnchor.constraint(equalToConstant: 60),
            imageView.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
        ])
    }
    
    private func setConstraints(for button: UIButton) {
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 48),
            button.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            button.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -90),
        ])
    }
    
    private func navigateToWebView() {
        let webViewViewController = WebViewViewController()
        
        let authHelper = UrlRequestConstructor()
        let webViewPresenter = WebViewPresenter(authHelper: authHelper)
        
        webViewPresenter.view = webViewViewController
        webViewViewController.presenter = webViewPresenter
        webViewViewController.delegate = self
        
        webViewViewController.modalPresentationStyle = .fullScreen
        present(webViewViewController, animated: true)
    }
}

// MARK: - WebViewViewControllerDelegate
extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true)
        delegate?.authViewController(self, didAuthenticateWith: code)
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
