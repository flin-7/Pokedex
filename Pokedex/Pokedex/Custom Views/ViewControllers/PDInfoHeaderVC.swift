//
//  PDUserInfoHeaderVC.swift
//  Pokedex
//
//  Created by Felix Lin on 2/12/20.
//  Copyright © 2020 Felix Lin. All rights reserved.
//

import UIKit

class PDInfoHeaderVC: UIViewController {
    
    let avatarImageView = PDAvatarImageView(frame: .zero)
    let pokemonNameLabel = PDTitleLabel(textAlignment: .left, fontSize: 34)
    let bioLabel = PDBodyLabel(textAlignment: .left)
    
    var imageUrl: String!
    var name: String!
    var bio: String!
    
    init(imageUrl: String, name: String, bio: String) {
        super.init(nibName: nil, bundle: nil)
        self.imageUrl = imageUrl
        self.name = name
        self.bio = bio
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubviews(avatarImageView, pokemonNameLabel, bioLabel)
        layoutUI()
        configureUIElement()
    }
    
    func configureUIElement() {
        avatarImageView.downloadImage(fromUrl: imageUrl)
        pokemonNameLabel.text = name.capitalized
        bioLabel.text = bio
        bioLabel.numberOfLines = 10
    }
    
    func layoutUI() {
        let padding: CGFloat = 20
        let textImagePadding: CGFloat = 12
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 120),
            avatarImageView.heightAnchor.constraint(equalToConstant: 120),
            
            pokemonNameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor, constant: 8),
            pokemonNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: textImagePadding),
            pokemonNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pokemonNameLabel.heightAnchor.constraint(equalToConstant: 38),
            
            bioLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: textImagePadding),
            bioLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            bioLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bioLabel.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
}
