//
//  PokemonInfoVC.swift
//  Pokedex
//
//  Created by Felix Lin on 2/11/20.
//  Copyright © 2020 Felix Lin. All rights reserved.
//

import UIKit

class PokemonInfoVC: UIViewController {
    
    var pokemonName: String!
    var pokemonURL: String!
    
    init(pokemonName: String, pokemonURL: String) {
        super.init(nibName: nil, bundle: nil)
        self.pokemonName = pokemonName
        self.pokemonURL = pokemonURL
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        
        let pokemonIndex = pokemonURL.split(separator: "/")[pokemonURL.split(separator: "/").count - 1]
        print(pokemonIndex)
        NetworkManager.shared.getPokemonFlavorText(pokemonIndex: String(pokemonIndex)) { [weak self] result in
            switch result {
            case .success(let pokeSpeciesInfo):
                for i in 0..<pokeSpeciesInfo.flavorTextEntries.count {
                    if pokeSpeciesInfo.flavorTextEntries[i].language.name == "en" {
                        print(pokeSpeciesInfo.flavorTextEntries[i].flavorText)
                        break
                    }
                }
            case .failure(let error):
                break
            }
        }
    }
    
    func configureViewController() {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.leftBarButtonItem = doneButton
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func addButtonTapped() {
        let pokemon = Pokemon(name: pokemonName, url: pokemonURL)
        
        PersistenceManager.updateWith(favorite: pokemon, actionType: .add) { [weak self] error in
            guard let self = self else { return }
            guard let error = error else {
                self.presentPDAlertOnMainThread(title: "Success!", message: "You have successfully favorited this pokemon🎉", buttonTitle: "Horray!")
                return
            }
            self.presentPDAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
        }
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
}

