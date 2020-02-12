//
//  PokemonSpecies.swift
//  Pokedex
//
//  Created by Felix Lin on 2/12/20.
//  Copyright © 2020 Felix Lin. All rights reserved.
//

import Foundation

struct PokemonSpecies: Codable {
    var flavorTextEntries: [FlavorTextEntries]
}

struct FlavorTextEntries: Codable {
    var flavorText: String
    var language: Language
}

struct Language: Codable {
    var name: String
    var url: String
}
