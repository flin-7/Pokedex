//
//  PokemonListVC.swift
//  Pokedex
//
//  Created by Felix Lin on 2/9/20.
//  Copyright © 2020 Felix Lin. All rights reserved.
//

import UIKit

class PokemonListVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        
        NetworkManager.shared.getPokemons(offset: 0) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let pokemons):
                print(pokemons.results.count)
            case .failure(let error):
                self.presentPDAlertOnMainThread(title: "Bad Stuff Happened", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
