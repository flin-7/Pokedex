//
//  String+Ext.swift
//  Pokedex
//
//  Created by Felix Lin on 2/12/20.
//  Copyright © 2020 Felix Lin. All rights reserved.
//

import UIKit

extension String {
    
    func getPokemonIndex() -> String {
        return String(self.split(separator: "/")[self.split(separator: "/").count - 1])
    }
}
