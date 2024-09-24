//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Rodion Kim on 13/08/2024.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    private let tokenStorage = OAuth2TokenStorage()
    
    let profileService = ProfileService.shared
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    private lazy var profileImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        guard let image = UIImage(named: "UserPic") else { return UIImageView() }
        view.image = image
        view.layer.cornerRadius = view.frame.size.width / 2
        view.clipsToBounds = true
        
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Екатерина Новикова"
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        guard let textColor = UIColor(named: "YP White") else { return UILabel() }
        label.textColor = textColor
        
        return label
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "@ekaterina_nov"
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        guard let textColor = UIColor(named: "YP Gray") else { return UILabel() }
        label.textColor = textColor
        
        return label
    }()
    
    private lazy var statusMessageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Hello, world."
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        guard let textColor = UIColor(named: "YP White") else { return UILabel() }
        label.textColor = textColor
        
        return label
    }()
    
    private lazy var exitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        guard let buttonImage = UIImage(named: "ExitButton") else { return UIButton() }
        button.setImage(buttonImage, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageServiceObserver = NotificationCenter.default.addObserver(forName: ProfileImageService.didChangeNotification,
                                                                             object: nil,
                                                                             queue: .main) { [weak self] _ in
            guard let self = self else { return }
            self.updateAvatar()
        }
        
        updateAvatar()
        
        self.view.backgroundColor = UIColor(named: "YP Black")
        
        self.view.addSubview(profileImageView)
        self.view.addSubview(nameLabel)
        self.view.addSubview(usernameLabel)
        self.view.addSubview(statusMessageLabel)
        self.view.addSubview(exitButton)
        
        setConstraints(for: profileImageView)
        
        setConstraints(for: nameLabel,
                       previousView: profileImageView,
                       height: 18,
                       leadingConstraint: 16,
                       topConstraint: 8)
        
        setConstraints(for: usernameLabel,
                       previousView: nameLabel,
                       height: 18,
                       leadingConstraint: 16,
                       topConstraint: 8)
        
        setConstraints(for: statusMessageLabel,
                       previousView: usernameLabel,
                       height: 18,
                       leadingConstraint: 16,
                       topConstraint: 8)
        
        setConstraints(for: exitButton, relativeTo: profileImageView)
        
        updateProfileDetails(with: profileService.profile)
    }
    
    @IBAction private func exitButtonAction(_ sender: Any) { }
    
    private func setConstraints(for imageView: UIImageView) {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 70),
            imageView.heightAnchor.constraint(equalToConstant: 70),
            imageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 32),
            imageView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
        ])
    }
    
    private func setConstraints(for label: UILabel,
                                previousView: UIView,
                                height: CGFloat,
                                leadingConstraint: CGFloat,
                                topConstraint: CGFloat) {
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: height),
            label.topAnchor.constraint(equalTo: previousView.bottomAnchor, constant: topConstraint),
            label.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: leadingConstraint),
        ])
    }
    
    private func setConstraints(for button: UIButton, relativeTo view: UIView) {
        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -14)
        ])
    }
    
    private func updateProfileDetails(with profile: Profile?) {
        nameLabel.text = profileService.profile?.name
        usernameLabel.text = profileService.profile?.loginName
        statusMessageLabel.text = profileService.profile?.bio
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.userPicURL,
            let url = URL(string: profileImageURL)
        else { return }
    }
}
