//
//  PDItemInfoView.swift
//  Pokedex
//
//  Created by Felix Lin on 2/13/20.
//  Copyright © 2020 Felix Lin. All rights reserved.
//

import UIKit

enum ItemInfoType {
    case info
}

class PDItemInfoView: UIView {
    
    let symbolImageView = UIImageView()
    let titleLabel = PDTitleLabel(textAlignment: .left, fontSize: 16)
    let descriptionLabel = PDTitleLabel(textAlignment: .center, fontSize: 16)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubviews(symbolImageView, titleLabel, descriptionLabel)
        
        symbolImageView.translatesAutoresizingMaskIntoConstraints = false
        symbolImageView.contentMode = .scaleAspectFill
        symbolImageView.tintColor = .label
        
        NSLayoutConstraint.activate([
            symbolImageView.topAnchor.constraint(equalTo: self.topAnchor),
            symbolImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            symbolImageView.widthAnchor.constraint(equalToConstant: 20),
            symbolImageView.heightAnchor.constraint(equalToConstant: 20),

            titleLabel.centerYAnchor.constraint(equalTo: symbolImageView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: symbolImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 18),

            descriptionLabel.topAnchor.constraint(equalTo: symbolImageView.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    func set(itemInfoType: ItemInfoType, withDescription description: String) {
        switch itemInfoType {
        case .info:
            symbolImageView.image = UIImage(systemName: SFSymbols.info)
            titleLabel.text = "Type"
        }
        
        descriptionLabel.text = description
    }
}
