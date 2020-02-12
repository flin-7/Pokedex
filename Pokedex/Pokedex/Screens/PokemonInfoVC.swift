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
    var pokemonIndex: String!
    
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
        let url = URL(string: "https://pokemon.fandom.com/wiki/\(name)")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    @objc func addButtonTapped() {

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
