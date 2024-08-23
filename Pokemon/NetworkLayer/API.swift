//
//  API.swift
//  Pokemon
//
//  Created by Dyana Arackal Varghese on 17/08/2024.
//

import Foundation
import Alamofire

// MARK: - Create API enum conforming to URLRequestBuilder, add the api name
enum API: URLRequestBuilder {
    case getPokemons(offset: Int)
    case getPokemonDetail(id: String)
}

// MARK: - Extend API to implement the inputs
extension API {

    var path: String {
        switch self {
        case .getPokemons:
            return "pokemon"
        case .getPokemonDetail(let id):
            return "pokemon/\(id)"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .getPokemons, .getPokemonDetail:
            return nil
        }
    }
        
    var method: HTTPMethod {
        switch self {
        case .getPokemons, .getPokemonDetail:
            return .get
        }
    }
    
    var queryItems: [String: Int]? {
        switch self {
        case .getPokemons(let offset):
            return ["offset": offset]
        case .getPokemonDetail:
            return nil
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .getPokemons, .getPokemonDetail:
            return ["Content-Type": "application/json"]
        }
    }
}
