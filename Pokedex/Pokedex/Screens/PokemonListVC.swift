//
//  PokemonListVC.swift
//  Pokedex
//
//  Created by Felix Lin on 2/9/20.
//  Copyright © 2020 Felix Lin. All rights reserved.
//

import UIKit

class PokemonListVC: UIViewController {
    
    enum Section {
        case main
    }
    
    var pokemons = [Pokemon]()
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Pokemon>!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureViewController()
        getPokemons()
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createThreeColumnFlowLayout())
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(PokemonCell.self, forCellWithReuseIdentifier: PokemonCell.reuseID)
    }
    
    func createThreeColumnFlowLayout() -> UICollectionViewFlowLayout {
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
    
    func getPokemons() {
        NetworkManager.shared.getPokemons(offset: 0) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let pokemons):
                self.pokemons = pokemons.results
                self.updateData()
            case .failure(let error):
                self.presentPDAlertOnMainThread(title: "Bad Stuff Happened", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Pokemon>(collectionView: collectionView, cellProvider: { collectionView, indexPath, pokemon -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonCell.reuseID, for: indexPath) as! PokemonCell
            cell.set(pokemon: pokemon)
            return cell
        })
    }
    
    func updateData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Pokemon>()
        snapshot.appendSections([.main])
        snapshot.appendItems(pokemons)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
}
