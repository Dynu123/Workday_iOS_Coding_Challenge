//
//  DetailViewModelTests.swift
//  Pokemon
//
//  Created by Dyana Arackal Varghese on 19/08/2024.
//

import XCTest
@testable import Pokemon
import Combine
import Alamofire

// MARK: - Unit tests for the DetailViewModel
final class DetailViewModelTests: XCTestCase {
    
    let viewModel = DetailViewModel(networkService: NetworkService())
    
    func testUrlOfThePokemonType() throws {
        // Given valid url for the type, verify the method returns valid url with correct Id
        let validType = Species.validType
        let expectedUrl = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/types/generation-vi/x-y/1.png"
        let actualUrl = viewModel.typeUrl(type: validType)
        XCTAssertEqual(expectedUrl, actualUrl)
        
        // Given invalid url for the type, verify the method returns empty string
        let invalidType = Species.invalidType
        let expectedUrl1 = ""
        let actualUrl1 = viewModel.typeUrl(type: invalidType)
        XCTAssertEqual(expectedUrl1, actualUrl1)
    }
    
    func testGetPokemonDetails() throws {
        guard let pokemon = Response.mockPokemons.first else { return }
        viewModel.getPokemonDetails(pokemon: pokemon){}
        XCTAssertEqual(viewModel.pokemonDetail.name, "Pikachu")
        XCTAssertEqual(viewModel.pokemonDetail.height, 22)
    }
}
