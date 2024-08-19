//
//  Pokemon.swift
//  Pokemon
//
//  Created by Dyana Arackal Varghese on 17/08/2024.
//

import Foundation

struct Response: Codable {
    let count: Int
    let results: [Pokemon]
}

struct Pokemon: Codable, Identifiable, Equatable {
    var id: UUID? = UUID()
    let name: String
    let url: String
}

extension Pokemon {
    static var sample = Pokemon(id: UUID(), name: "", url: "")
}
