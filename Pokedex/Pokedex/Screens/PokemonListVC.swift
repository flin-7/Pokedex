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
    var offset = 0
    var hasMorePokemons = true
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Pokemon>!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureViewController()
        getPokemons(offset: offset)
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
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        collectionView.delegate = self
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(PokemonCell.self, forCellWithReuseIdentifier: PokemonCell.reuseID)
    }
    
    func getPokemons(offset: Int) {
        showLoadingView()
        NetworkManager.shared.getPokemons(offset: offset) { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            
            switch result {
            case .success(let pokemons):
                self.pokemons.append(contentsOf: pokemons.results)
                self.updateData()
            case .failure(let error):
                if self.pokemons.isEmpty {
                    let message = error.rawValue
                    DispatchQueue.main.async {
                        self.showEmptyStateView(with: message, in: self.view)
                    }
                }
                
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

extension PokemonListVC: UICollectionViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            guard hasMorePokemons else { return }
            offset += 25
            getPokemons(offset: offset)
        }
    }
}
