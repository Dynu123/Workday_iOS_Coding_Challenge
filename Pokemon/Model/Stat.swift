//
//  Stat.swift
//  Pokemon
//
//  Created by Dyana Arackal Varghese on 22/08/2024.
//

import Foundation

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
