//
//  FavoriteCell.swift
//  Pokedex
//
//  Created by Felix Lin on 2/11/20.
//  Copyright © 2020 Felix Lin. All rights reserved.
//

import UIKit

class FavoriteCell: UITableViewCell {
    
    static let reuseID = "FavoriteCell"
    
    let avatarImageView = PDAvatarImageView(frame: .zero)
    let pokenameLabel = PDTitleLabel(textAlignment: .left, fontSize: 26)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(pokemon: Pokemon) {
        pokenameLabel.text = pokemon.name.capitalized
        let pokemonIndex = pokemon.url.split(separator: "/")[pokemon.url.split(separator: "/").count - 1]
        let imageUrl = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(pokemonIndex).png"
        NetworkManager.shared.downloadImage(from: imageUrl) { [weak self] image in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.avatarImageView.image = image
            }
        }
    }
    
    private func configure() {
        addSubview(avatarImageView)
        addSubview(pokenameLabel)

        accessoryType = .disclosureIndicator
        let padding: CGFloat = 12

        NSLayoutConstraint.activate([
            avatarImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            avatarImageView.heightAnchor.constraint(equalToConstant: 60),
            avatarImageView.widthAnchor.constraint(equalToConstant: 60),

            pokenameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            pokenameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 24),
            pokenameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            pokenameLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
