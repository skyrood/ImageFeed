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
    
    weak var delegate: AuthViewControllerDelegate?
    
    let oauth2Service = OAuth2Service.shared
    
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
    
    private let ShowWebViewSegueIdentifier = "ShowWebView"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(named: "YP Black")
        self.view.addSubview(logoView)
        self.view.addSubview(signinButton)
        
        setConstraints(for: logoView)
        setConstraints(for: signinButton)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowWebViewSegueIdentifier {
            guard let webViewViewController = segue.destination as? WebViewViewController else {
                fatalError("Failed to prepare for \(ShowWebViewSegueIdentifier)")
            }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    @objc private func signinButtonTapped() {
        performSegue(withIdentifier: ShowWebViewSegueIdentifier, sender: self)
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
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        
        delegate?.authViewController(self, didAuthenticateWith: code)
        
//        oauth2Service.fetchOAuthToken(code: code) { result in
//            switch result {
//            case .success( _ ):
//                print("access token stored successfully.")
//                
////                vc.dismiss(animated: true, completion: nil)
//                
//            case .failure(let error):
//                self.handleError(error)
//            }
//        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
    
    private func handleError(_ error: Error) {
        if let networkError = error as? NetworkError {
            switch networkError {
            case .httpStatusCode(let statusCode):
                print("HTTP error occurred. Error code: \(statusCode)")
            case .urlRequestError(let urlError):
                print("URL request error: \(urlError)")
            case .urlSessionError:
                print("Session error")
            }
        } else {
            print("Error occurred: \(error.localizedDescription)")
        }
    }
}
