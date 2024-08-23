//
//  PokemonDetail.swift
//  Pokemon
//
//  Created by Dyana Arackal Varghese on 17/08/2024.
//

import Foundation

// MARK: - Pokemon Detail
struct PokemonDetail: Codable {
    let height: Int
    let id: Int
    let name: String
    let species: Species
    let sprites: Sprites
    let stats: [Stat]
    let types: [TypeElement]
    let weight: Int
    
    enum CodingKeys: String, CodingKey {
        case height
        case id
        case name
        case species, sprites, stats, types, weight
    }
}

// MARK: - Set values
extension PokemonDetail {
    static let mockPokemonDetail = PokemonDetail(height: 22,
                                                 id: 1,
                                                 name: "Pikachu",
                                                 species: Species(name: "Normal", url: ""),
                                                 sprites: Sprites(backDefault: "",
                                                                  backFemale: "",
                                                                  backShiny: "",
                                                                  backShinyFemale: "",
                                                                  frontDefault: "",
                                                                  frontFemale: "",
                                                                  frontShiny: "",
                                                                  frontShinyFemale: ""),
                                                 stats: [],
                                                 types: [TypeElement(slot: 1, type: Species.validType)],
                                                 weight: 32)
}





