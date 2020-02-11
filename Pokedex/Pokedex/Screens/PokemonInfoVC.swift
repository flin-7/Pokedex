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
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.leftBarButtonItem = doneButton
        loadWebPage(pokemon: pokemonName)
    }
    
    func loadWebPage(pokemon name: String) {
        let url = URL(string: "https://pokemon.fandom.com/wiki/\(name)")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
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
