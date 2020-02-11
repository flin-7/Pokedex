//
//  Pokemon.swift
//  Pokedex
//
//  Created by Felix Lin on 2/10/20.
//  Copyright © 2020 Felix Lin. All rights reserved.
//

import Foundation

struct Pokemon: Codable {
    let name: String
    let url: String
}

struct Pokemons: Codable {
    var results: [Pokemon]
}
