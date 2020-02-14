//
//  PDTypeItemVC.swift
//  Pokedex
//
//  Created by Felix Lin on 2/14/20.
//  Copyright © 2020 Felix Lin. All rights reserved.
//

import UIKit

class PDTypeItemVC: PDItemInfoVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    private func configureItems() {
        var type = ""
        for i in 0..<pokemonDetail.types.count {
            type += pokemonDetail.types[i].type.name.capitalized + " "
        }
        itemInfoViewOne.set(itemInfoType: .info, withDescription: type)
        actionButton.set(backgroundColor: .systemGreen, title: "Profile on Wiki")
    }
}
