//
//  UIHelper.swift
//  Pokedex
//
//  Created by Felix Lin on 2/11/20.
//  Copyright © 2020 Felix Lin. All rights reserved.
//

import UIKit

enum UIHelper {
    
    static func createThreeColumnFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let padding: CGFloat = 12
        let minimumItemSpacing: CGFloat = 10
        let availableWidth = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth = availableWidth / 3
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40)
        
        return flowLayout
    }
    
    static func getPokemonImegrURL(for pokemonIndex: String) -> String {
        var imageUrl = ""
        if let pokemonIndex = Int(pokemonIndex) {
            imageUrl = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(pokemonIndex).png"
        }
        return imageUrl
    }
}
