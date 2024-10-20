//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Rodion Kim on 29/08/2024.
//

import UIKit
@preconcurrency import WebKit

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

public protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    func load(_ request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
}

final class WebViewViewController: UIViewController & WebViewViewControllerProtocol {

    // MARK: - Public Properties
    weak var delegate: WebViewViewControllerDelegate?
    
    var presenter: WebViewPresenterProtocol?

    // MARK: - Private Properties
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    private lazy var progressBar: UIProgressView = {
        let progressBar = UIProgressView()
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        
        progressBar.progressTintColor = UIColor(named: "YP Black") ?? .black
        
        return progressBar
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        guard let buttonImage = UIImage(named: "nav_back_button") else { return UIButton() }
        button.setImage(buttonImage, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 9, left: 9, bottom: 9, right: 9)
        
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)

        return button
    }()
    
    private lazy var webView: WKWebView = {
        let view = WKWebView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.allowsBackForwardNavigationGestures = true
        
        view.accessibilityIdentifier = "UnsplashWebView" 
        
        return view
    }()

    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] _, _ in
                 guard let self else { return }
                 
                 presenter?.didUpdateProgressValue(webView.estimatedProgress)
             }
        )
        
        webView.navigationDelegate = self
                
        self.view.backgroundColor = UIColor(named: "YP White") ?? UIColor.white
        
        self.view.addSubview(backButton)
        self.view.addSubview(webView)
        self.view.addSubview(progressBar)
        
        setConstraints(for: backButton)
        setConstraints(for: webView, relativeTo: backButton)
        setConstraints(for: progressBar, relativeTo: backButton)
        
        presenter?.viewDidLoad()
    }
    
    // MARK: - Public Methods
    func load(_ request: URLRequest) {
        webView.load(request)
    }
    
    func setProgressValue(_ newValue: Float) {
        progressBar.setProgress(newValue, animated: true)
    }

    func setProgressHidden(_ isHidden: Bool) {
        progressBar.isHidden = isHidden
    }

    // MARK: - Private Methods
    @objc private func backButtonTapped() {
        delegate?.webViewViewControllerDidCancel(self)
    }
    
    private func setConstraints(for backButton: UIButton) {
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            backButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
        ])
    }
    
    private func setConstraints(for webView: WKWebView, relativeTo view: UIView) {
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            webView.topAnchor.constraint(equalTo: view.bottomAnchor),
            webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
        ])
    }
    
    private func setConstraints(for progressBar: UIProgressView, relativeTo view: UIView ){
        NSLayoutConstraint.activate([
            progressBar.topAnchor.constraint(equalTo: view.bottomAnchor),
            progressBar.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

// MARK: - WKNavigationDelegate
extension WebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, 
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
                
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url {
            return presenter?.code(from: url)
        } else {
            return nil
        }
    }
}
