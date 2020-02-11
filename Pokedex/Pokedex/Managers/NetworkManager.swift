//
//  NetworkManager.swift
//  Pokedex
//
//  Created by Felix Lin on 2/10/20.
//  Copyright © 2020 Felix Lin. All rights reserved.
//

import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://pokeapi.co/api/v2/pokemon"
    let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func getPokemons(offset: Int, completed: @escaping (Result<Pokemons, PDError>) -> Void) {
        let endpoint = baseURL + "?limit=25&offset=\(offset)"
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidEndpoint))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let pokemons = try decoder.decode(Pokemons.self, from: data)
                completed(.success(pokemons))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
}
