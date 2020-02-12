//
//  PDAvatarImageView.swift
//  Pokedex
//
//  Created by Felix Lin on 2/11/20.
//  Copyright © 2020 Felix Lin. All rights reserved.
//

import UIKit

class PDAvatarImageView: UIImageView {
    let cache = NetworkManager.shared.cache
    let placeholderImage = Image.placeholder
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeholderImage
        tintColor = .systemGray
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func downloadImage(fromUrl url: String) {
        NetworkManager.shared.downloadImage(from: url) { [weak self] image in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
}
