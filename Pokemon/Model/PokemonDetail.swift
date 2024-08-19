//
//  PokemonDetail.swift
//  Pokemon
//
//  Created by Dyana Arackal Varghese on 17/08/2024.
//

import Foundation

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

// MARK: - Stat
struct Stat: Codable, Identifiable {
    let id: UUID? = UUID()
    let baseStat, effort: Int
    let stat: Species

    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case effort, stat, id
    }
}

// MARK: - TypeElement
struct TypeElement: Codable {
    let slot: Int
    let type: Species
}

// MARK: - Species
struct Species: Codable {
    let name: String
    let url: String
}

extension Species {
    static let validType = Species(name: "normal", url: "https://pokeapi.co/api/v2/type/1/")
    static let invalidType = Species(name: "normal", url: "")
}

// MARK: - Sprites
class Sprites: Codable, Identifiable {
    let id: UUID? = UUID()
    let backDefault: String
    let backFemale: String?
    let backShiny: String
    let backShinyFemale: String?
    let frontDefault: String
    let frontFemale: String?
    let frontShiny: String
    let frontShinyFemale: String?

    enum CodingKeys: String, CodingKey {
        case backDefault = "back_default"
        case backFemale = "back_female"
        case backShiny = "back_shiny"
        case backShinyFemale = "back_shiny_female"
        case frontDefault = "front_default"
        case frontFemale = "front_female"
        case frontShiny = "front_shiny"
        case frontShinyFemale = "front_shiny_female"
    }

    init(backDefault: String, backFemale: String?, backShiny: String, backShinyFemale: String?, frontDefault: String, frontFemale: String?, frontShiny: String, frontShinyFemale: String?) {
        self.backDefault = backDefault
        self.backFemale = backFemale
        self.backShiny = backShiny
        self.backShinyFemale = backShinyFemale
        self.frontDefault = frontDefault
        self.frontFemale = frontFemale
        self.frontShiny = frontShiny
        self.frontShinyFemale = frontShinyFemale
    }
}


extension PokemonDetail {
    
    static let sample = PokemonDetail(height: 1, 
                                      id: 1,
                                      name: "sample",
                                      species: Species(name: "sample species", url: ""),
                                      sprites: Sprites(backDefault: "", 
                                                       backFemale: "",
                                                       backShiny: "",
                                                       backShinyFemale: "",
                                                       frontDefault: "",
                                                       frontFemale: "",
                                                       frontShiny: "",
                                                       frontShinyFemale: ""),
                                      stats: [],
                                      types: [],
                                      weight: 20)
}
