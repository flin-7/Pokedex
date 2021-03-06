//
//  PDTypeItemVC.swift
//  Pokedex
//
//  Created by Felix Lin on 2/14/20.
//  Copyright © 2020 Felix Lin. All rights reserved.
//

import UIKit

protocol PDTypeItemVCDelegate: class {
    func didTapWikiProfile(for pokemonDetail: PokemonDetail)
}

class PDTypeItemVC: PDItemInfoVC {
    
    weak var delegate: PDTypeItemVCDelegate!
    
    init(pokemonDetail: PokemonDetail, delegate: PDTypeItemVCDelegate) {
        super.init(pokemonDetail: pokemonDetail)
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    private func configureItems() {
        var type = ""
        var abilityDesc = ""
        for i in 0..<pokemonDetail.types.count {
            type += pokemonDetail.types[i].type.name.capitalized + "\n"
        }
        for i in 0..<pokemonDetail.abilities.count {
            abilityDesc += pokemonDetail.abilities[i].ability.name.capitalized + "\n"
        }
        itemInfoViewOne.set(itemInfoType: .info, withDescription: type)
        itemInfoViewTwo.set(itemInfoType: .abilityInfo, withDescription: abilityDesc)
//        actionButton.set(backgroundColor: .systemGreen, title: "Profile on Pokedex")
    }
    
    override func actionButtonTapped() {
        delegate.didTapWikiProfile(for: pokemonDetail)
    }
}
