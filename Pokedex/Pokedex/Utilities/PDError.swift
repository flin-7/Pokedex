//
//  PDError.swift
//  Pokedex
//
//  Created by Felix Lin on 2/10/20.
//  Copyright © 2020 Felix Lin. All rights reserved.
//

import Foundation

enum PDError: String, Error {
    case invalidEndpoint = "This endpoint created an invalid request. Please try again."
    case unableToComplete = "Unable to complete your request. Please check your internet connection."
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data received from the server was invalid. Please try again."
    case unableToFavorite = "There was an error favoriting this user. Please try again."
    case alreadyInFavorites = "You've already favorited this pokemon. You must REALLY like them!"
}
