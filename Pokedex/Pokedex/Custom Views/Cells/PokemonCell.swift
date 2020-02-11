//
//  PokemonCell.swift
//  Pokedex
//
//  Created by Felix Lin on 2/10/20.
//  Copyright © 2020 Felix Lin. All rights reserved.
//

import UIKit

class PokemonCell: UICollectionViewCell {
    static let reuseID = "PokemonCell"
    
    let avatarImageView = PDAvatarImageView(frame: .zero)
    let pokenameLabel = PDTitleLabel(textAlignment: .center, fontSize: 16)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(pokemon: Pokemon) {
        pokenameLabel.text = pokemon.name.capitalized
        let pokemonIndex = pokemon.url.split(separator: "/")[pokemon.url.split(separator: "/").count - 1]
        let imageUrl = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(pokemonIndex).png"
        avatarImageView.downloadImage(from: imageUrl)
    }
    
    private func configure() {
        addSubview(avatarImageView)
        addSubview(pokenameLabel)
        
        let padding: CGFloat = 8
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            avatarImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            
            pokenameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            pokenameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            pokenameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            pokenameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
