//
//  Species.swift
//  Pokemon
//
//  Created by Dyana Arackal Varghese on 22/08/2024.
//

import Foundation

// MARK: - Species
struct Species: Codable {
    let name: String
    let url: String
}

extension Species {
    static let validType = Species(name: "normal", url: "https://pokeapi.co/api/v2/type/1/")
    static let invalidType = Species(name: "normal", url: "")
}
