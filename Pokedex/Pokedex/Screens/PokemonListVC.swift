//
//  PokemonListVC.swift
//  Pokedex
//
//  Created by Felix Lin on 2/9/20.
//  Copyright © 2020 Felix Lin. All rights reserved.
//

import UIKit

class PokemonListVC: PDDataLoadingVC {
    
    enum Section {
        case main
    }
    
    var pokemons = [Pokemon]()
    var filteredPokemons = [Pokemon]()
    var offset = 0
    var hasMorePokemons = true
    var isSearching = false
    var isLoadingMorePokemons = false
    
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
        searchController.searchBar.placeholder = "Search"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    
    func getPokemons(offset: Int) {
        showLoadingView()
        isLoadingMorePokemons = true
        
        NetworkManager.shared.getPokemons(offset: offset) { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            
            switch result {
            case .success(let pokemons):
                self.updateUI(with: pokemons)
            case .failure(let error):
                self.presentPDAlertOnMainThread(title: "Bad Stuff Happened", message: error.rawValue, buttonTitle: "Ok")
                
                if self.pokemons.isEmpty {
                    let message = error.rawValue
                    DispatchQueue.main.async {
                        self.showEmptyStateView(with: message, in: self.view)
                    }
                }
            }
            self.isLoadingMorePokemons = false
        }
    }
    
    func updateUI(with pokemons: Pokemons) {
        if pokemons.results.count < 100 {
            self.hasMorePokemons = false
        }
        self.pokemons.append(contentsOf: pokemons.results)
        self.updateData(on: self.pokemons)
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
            guard hasMorePokemons, !isLoadingMorePokemons else { return }
            offset += 100
            getPokemons(offset: offset)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray = isSearching ? filteredPokemons : pokemons
        let pokemon = activeArray[indexPath.item]
        
        let destVC = PokemonInfoVC(pokemonName: pokemon.name, pokemonURL: pokemon.url)
        let navController = UINavigationController(rootViewController: destVC)
        present(navController, animated: true)
    }
}

extension PokemonListVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            filteredPokemons.removeAll()
            updateData(on: pokemons)
            isSearching = false
            return
        }
        isSearching = true
        filteredPokemons = pokemons.filter { $0.name.lowercased().contains(filter.lowercased()) }
        updateData(on: filteredPokemons)
    }
}

extension PokemonListVC: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        
        if tabBarIndex == 0 {
            self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        }
    }
}
