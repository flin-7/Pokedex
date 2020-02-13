//
//  PokemonInfoVC.swift
//  Pokedex
//
//  Created by Felix Lin on 2/11/20.
//  Copyright © 2020 Felix Lin. All rights reserved.
//

import UIKit

protocol PokemonInfoVCDelegate: class {
    
}

class PokemonInfoVC: PDDataLoadingVC {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let headerView = UIView()
    let itemViewOne = UIView()
    var itemViews = [UIView]()
    
    var pokemonName: String!
    var pokemonURL: String!
    var falvorText: String!
    var pokemonType: String!
    var pokemonBio: String!
    
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
        configureScrollView()
        layoutUI()
        getPokemonFlavorText()
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.leftBarButtonItem = doneButton
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    func configureScrollView() {
        view.addSubviews(scrollView)
        scrollView.addSubviews(contentView)
        scrollView.pinToEdges(of: view)
        contentView.pinToEdges(of: scrollView)
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 600)
        ])
    }
    
    func getPokemonFlavorText() {
        let pokemonIndex = pokemonURL.getPokemonIndex()
        NetworkManager.shared.getPokemonFlavorText(pokemonIndex: String(pokemonIndex)) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let pokeSpeciesInfo):
                for i in 0..<pokeSpeciesInfo.flavorTextEntries.count {
                    if pokeSpeciesInfo.flavorTextEntries[i].language.name == "en" {
                        DispatchQueue.main.async {
                            self.configureUIElement(bio: pokeSpeciesInfo.flavorTextEntries[i].flavorText)
                        }
                        break
                    }
                }
            case .failure(let error):
                self.presentPDAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    func getPokemonDetail() {
        let pokemonIndex = pokemonURL.getPokemonIndex()
        NetworkManager.shared.getPokemonDetail(pokemonIndex: String(pokemonIndex)) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let pokemonDetail):
                for type in pokemonDetail.types {
                    print(type.type)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func configureUIElement(bio: String) {
        let pokemonIndex = pokemonURL.getPokemonIndex()
        var imageUrl = ""
        if let pokemonIndex = Int(pokemonIndex) {
            if pokemonIndex < 10 {
                imageUrl = "https://assets.pokemon.com/assets/cms2/img/pokedex/full/00\(pokemonIndex).png"
            } else if pokemonIndex < 100 {
                imageUrl = "https://assets.pokemon.com/assets/cms2/img/pokedex/full/0\(pokemonIndex).png"
            } else {
                imageUrl = "https://assets.pokemon.com/assets/cms2/img/pokedex/full/\(pokemonIndex).png"
            }
        }
        
        self.add(childVC: PDInfoHeaderVC(imageUrl: imageUrl, name: pokemonName, bio: bio), to: self.headerView)
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
    
    func layoutUI() {
        let padding: CGFloat = 20
        let itemHeight: CGFloat = 140
        
        itemViews = [headerView, itemViewOne]
        
        for itemView in itemViews {
            contentView.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
            ])
        }
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 210),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
        ])
    }
    
    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
}

