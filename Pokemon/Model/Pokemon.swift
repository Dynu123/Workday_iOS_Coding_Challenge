//
//  Pokemon.swift
//  Pokemon
//
//  Created by Dyana Arackal Varghese on 17/08/2024.
//

import Foundation

struct Response: Codable, Equatable {
    let count: Int
    let results: [Pokemon]
}

struct Pokemon: Codable, Identifiable, Equatable {
    var id: UUID? = UUID()
    let name: String
    let url: String
}

extension Response {
    static let mockResponse = Response(count: 1302, results: mockPokemons)
    static let mockPokemons = [Pokemon(name: "Pikachu", url: "https://pokeapi.co/api/v2/pokemon/1/"),
                         Pokemon(name: "Ditto", url: "https://pokeapi.co/api/v2/pokemon/2/"),
                         Pokemon(name: "Dingle", url: "https://pokeapi.co/api/v2/pokemon/3/"),
                         Pokemon(name: "Bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/4/"),
                         Pokemon(name: "Ivysaur", url: "https://pokeapi.co/api/v2/pokemon/5/")]
}
