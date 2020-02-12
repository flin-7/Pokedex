//
//  PokemonDetail.swift
//  Pokedex
//
//  Created by Felix Lin on 2/12/20.
//  Copyright © 2020 Felix Lin. All rights reserved.
//

import Foundation

struct PokemonDetail: Codable {
    let id: Int
    let name: String
    let weight: Int
    let height: Int
    let types: Types
    let abilities: Abilities
}

struct Abilities: Codable {
    var ability: [Ability]
}

struct Ability: Codable {
    let name: String
    let url: String
}

struct Types: Codable {
    let type: Type
}

struct Type: Codable {
    let name: String
    let url: String
}
