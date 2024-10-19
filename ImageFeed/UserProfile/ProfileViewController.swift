//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Rodion Kim on 13/08/2024.
//

import UIKit
import Kingfisher

protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfileViewPresenterProtocol? { get set }
    
    var nameLabel: UILabel { get set }
    var usernameLabel: UILabel { get set }
    var statusMessageLabel: UILabel { get set }
    var profileImageView: UIImageView { get set }
    
    func updateAvatar()
    func navigate(to vc: UIViewController)
    
}

final class ProfileViewController: UIViewController & ProfileViewControllerProtocol {

    // MARK: - Public Properties
    var presenter: ProfileViewPresenterProtocol?
    
    lazy var profileImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 35
        view.clipsToBounds = true
        view.image = UIImage(named: "UserAvatarPlaceholder")
        
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        guard let textColor = UIColor(named: "YP White") else { return UILabel() }
        label.textColor = textColor
        
        return label
    }()
    
    lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        guard let textColor = UIColor(named: "YP Gray") else { return UILabel() }
        label.textColor = textColor
        
        return label
    }()
    
    lazy var statusMessageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        guard let textColor = UIColor(named: "YP White") else { return UILabel() }
        label.textColor = textColor
        
        return label
    }()

    // MARK: - Private Properties
    private lazy var exitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        guard let buttonImage = UIImage(named: "ExitButton") else { return UIButton() }
        button.setImage(buttonImage, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.addTarget(self, action: #selector(logout), for: .touchUpInside)
        
        return button
    }()

    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoad()
        
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
        
        updateProfileDetails()
    }

    // MARK: - IB Actions
    @IBAction private func exitButtonAction(_ sender: Any) { }
    
    // MARK: - Public Methods
    func updateAvatar() {
        let url = presenter?.avatarURL()
        
        profileImageView.kf.setImage(with: url, placeholder: UIImage(named: "UserAvatarPlaceholder"))
    }
    
    func navigate(to vc: UIViewController) {
        self.present(vc, animated: true, completion: nil)
    }

    // MARK: - Private Methods
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
    
    private func updateProfileDetails() {
        print("presenting profile...")
        let profileDetails = presenter?.profileDetails()
        
        nameLabel.text = profileDetails?.name
        usernameLabel.text = profileDetails?.username
        statusMessageLabel.text = profileDetails?.bio
    }
    
    @objc private func logout() {
        showLogoutPromptAlert(vc: self)
    }
    
    private func showLogoutPromptAlert(vc: UIViewController) {
        let alert = UIAlertController(title: "Пока, пока!", message: "Уверены, что хотите выйти?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Нет", style: .default, handler: nil)
        let logoutAction = UIAlertAction(title: "Да", style: .cancel) { [weak self] _ in
            self?.presenter?.logout()
        }
        
        alert.addAction(logoutAction)
        alert.addAction(cancelAction)
        
        vc.present(alert, animated: true, completion: nil)
    }
}
