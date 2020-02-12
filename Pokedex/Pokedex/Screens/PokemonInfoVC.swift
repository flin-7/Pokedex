//
//  PokemonInfoVC.swift
//  Pokedex
//
//  Created by Felix Lin on 2/11/20.
//  Copyright © 2020 Felix Lin. All rights reserved.
//

import UIKit
import WebKit

class PokemonInfoVC: UIViewController {
    
    var webView: WKWebView!
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
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        loadWebPage(pokemon: pokemonName)
    }
    
    func configureViewController() {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.leftBarButtonItem = doneButton
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    func loadWebPage(pokemon name: String) {
        let url = URL(string: "https://www.pokemon.com/us/pokedex/\(name)")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
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

extension PokemonInfoVC: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
}
