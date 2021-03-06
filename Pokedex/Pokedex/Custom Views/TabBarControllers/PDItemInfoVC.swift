//
//  PDItemInfoVC.swift
//  Pokedex
//
//  Created by Felix Lin on 2/14/20.
//  Copyright © 2020 Felix Lin. All rights reserved.
//

import UIKit

class PDItemInfoVC: UIViewController {
    
    let stackView = UIStackView()
    let itemInfoViewOne = PDItemInfoView()
    let itemInfoViewTwo = PDItemInfoView()
    let actionButton = PDButton()
    
    var pokemonDetail: PokemonDetail!
    
    init(pokemonDetail: PokemonDetail) {
        super.init(nibName: nil, bundle: nil)
        self.pokemonDetail = pokemonDetail
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackgroundView()
        layoutUI()
        configureStackView()
//        configureActionButton()
    }

    func configureBackgroundView() {
        view.layer.cornerRadius = 18
        view.backgroundColor = .secondarySystemBackground
    }
    
    private func configureStackView() {
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing

        stackView.addArrangedSubview(itemInfoViewOne)
        stackView.addArrangedSubview(itemInfoViewTwo)
    }
    
    private func configureActionButton() {
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
    }
    
    @objc func actionButtonTapped() {
        
    }
    
    private func layoutUI() {
        view.addSubview(stackView)
//        view.addSubview(actionButton)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        let padding: CGFloat = 20

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            stackView.heightAnchor.constraint(equalToConstant: 94),

//            actionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding),
//            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
//            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
//            actionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}
