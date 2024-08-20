//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Rodion Kim on 13/08/2024.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBAction func exitButtonAction(_ sender: Any) { }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(named: "YP Black")
        
        let profileImageView = UIImageView()
        let nameLabel = UILabel()
        let usernameLabel = UILabel()
        let statusMessageLabel = UILabel()
        let exitButton = UIButton()
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        statusMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(profileImageView)
        self.view.addSubview(nameLabel)
        self.view.addSubview(usernameLabel)
        self.view.addSubview(statusMessageLabel)
        self.view.addSubview(exitButton)
        
        setConstraints(for: profileImageView)
        
        setConstraints(for: nameLabel,
                       text: "Екатерина Новикова",
                       previousView: profileImageView,
                       fontSize: 23,
                       height: 18,
                       fontWeight: .bold,
                       textColor: UIColor(named: "YP White"),
                       leadingConstraint: 16,
                       topConstraint: 8)
        
        setConstraints(for: usernameLabel,
                       text: "@ekaterina_nov",
                       previousView: nameLabel,
                       fontSize: 13,
                       height: 18,
                       fontWeight: .regular,
                       textColor: UIColor(named: "YP Gray"),
                       leadingConstraint: 16,
                       topConstraint: 8)
        
        setConstraints(for: statusMessageLabel,
                       text: "Hello, world.",
                       previousView: usernameLabel,
                       fontSize: 13,
                       height: 18,
                       fontWeight: .regular,
                       textColor: UIColor(named: "YP White"),
                       leadingConstraint: 16,
                       topConstraint: 8)
        
        setConstraints(for: exitButton, relativeTo: profileImageView)
    }
    
    private func setConstraints(for imageView: UIImageView) {
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        
        let profileImage = UIImage(named: "UserPic")
        imageView.image = profileImage
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 70),
            imageView.heightAnchor.constraint(equalToConstant: 70),
            imageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 32),
            imageView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
        ])
    }
    
    private func setConstraints(for label: UILabel,
                                text: String,
                                previousView: UIView,
                                fontSize: CGFloat,
                                height: CGFloat,
                                fontWeight: UIFont.Weight,
                                textColor: UIColor?,
                                leadingConstraint: CGFloat,
                                topConstraint: CGFloat) {
        label.text = text
        label.font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        guard let textColor else { return }
        label.textColor = textColor
        
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: height),
            label.topAnchor.constraint(equalTo: previousView.bottomAnchor, constant: topConstraint),
            label.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: leadingConstraint),
        ])
    }
    
    private func setConstraints(for button: UIButton, relativeTo view: UIView) {
        button.setImage(UIImage(named: "ExitButton"), for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -14)
        ])
    }
}
