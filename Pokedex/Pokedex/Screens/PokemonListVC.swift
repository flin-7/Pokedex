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
    var filteredPokemons = [Pokemon]()
    var offset = 0
    var hasMorePokemons = true
    var isSearching = false
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Pokemon>!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureSearchController()
        configureCollectionView()
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
        self.tabBarController?.delegate = self
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        collectionView.delegate = self
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(PokemonCell.self, forCellWithReuseIdentifier: PokemonCell.reuseID)
    }
    
    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for a pokemon"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    
    func getPokemons(offset: Int) {
        showLoadingView()
        NetworkManager.shared.getPokemons(offset: offset) { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            
            switch result {
            case .success(let pokemons):
                if pokemons.results.count < 100 {
                    self.hasMorePokemons = false
                }
                self.pokemons.append(contentsOf: pokemons.results)
                self.updateData(on: self.pokemons)
            case .failure(let error):
                self.presentPDAlertOnMainThread(title: "Bad Stuff Happened", message: error.rawValue, buttonTitle: "Ok")
                
                if self.pokemons.isEmpty {
                    let message = error.rawValue
                    DispatchQueue.main.async {
                        self.showEmptyStateView(with: message, in: self.view)
                    }
                }
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
    
    func updateData(on pokemons: [Pokemon]) {
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
            offset += 100
            getPokemons(offset: offset)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray = isSearching ? filteredPokemons : pokemons
        let pokemon = activeArray[indexPath.item]
        
        let destVC = PokemonInfoVC()
        destVC.pokemonName = pokemon.name
        destVC.pokemonURL = pokemon.url
        let navController = UINavigationController(rootViewController: destVC)
        present(navController, animated: true)
    }
}

extension PokemonListVC: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else { return }
        isSearching = true
        filteredPokemons = pokemons.filter { $0.name.lowercased().contains(filter.lowercased()) }
        updateData(on: filteredPokemons)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        updateData(on: pokemons)
    }
}

extension PokemonListVC: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        
        if tabBarIndex == 0 {
            self.collectionView.setContentOffset(CGPoint(x: 0, y: -100), animated: true)
        }
    }
}
