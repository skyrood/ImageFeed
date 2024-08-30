//
//  WebViewViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Rodion Kim on 30/08/2024.
//

import Foundation

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
