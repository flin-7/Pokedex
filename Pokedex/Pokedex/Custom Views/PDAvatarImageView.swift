//
//  PDAvatarImageView.swift
//  Pokedex
//
//  Created by Felix Lin on 2/11/20.
//  Copyright © 2020 Felix Lin. All rights reserved.
//

import UIKit

class PDAvatarImageView: UIImageView {
    let placeholderImage = UIImage(systemName: "questionmark")!
    
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
        translatesAutoresizingMaskIntoConstraints = false
    }
}
