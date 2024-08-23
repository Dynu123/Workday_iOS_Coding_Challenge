//
//  PokemonTests.swift
//  PokemonTests
//
//  Created by Dyana Arackal Varghese on 17/08/2024.
//

import XCTest
@testable import Pokemon
import Combine
import Alamofire

// MARK: - Unit tests for the HomeViewModel
final class HomeViewModelTests: XCTestCase {
    
    let viewModel       = HomeViewModel(networkService: MockNetworkService())
    
    func testHasReachedEndOfPokemonList() throws {
        viewModel.pokemons = Response.mockPokemons
        
        // Given last pokemon from the pokemon list, verify method returns true
        guard let lastPokemon = Response.mockPokemons.last else { return }
        let hasReachedEnd1 = viewModel.hasReachedEnd(of: lastPokemon)
        XCTAssertEqual(hasReachedEnd1, true)
        
        
        // Given first pokemon from the pokemon list, verify method returns false
        guard let firstPokemon = Response.mockPokemons.first else { return }
        let hasReachedEnd2 = viewModel.hasReachedEnd(of: firstPokemon)
        XCTAssertEqual(hasReachedEnd2, false)
    }
    
    func testSearchPokemons() throws {
        viewModel.pokemons = Response.mockPokemons
        
        // Given a search text verify a single pokemon instance is matched
        viewModel.searchText = "Pikachu"
        let expectedSearchResult = Response.mockPokemons.filter { $0.name.localizedCaseInsensitiveContains(viewModel.searchText)}
        let actualSearchResult = viewModel.searchResults.filter { $0.name.localizedCaseInsensitiveContains(viewModel.searchText)}
        XCTAssertEqual(expectedSearchResult.first?.name, actualSearchResult.first?.name)
        XCTAssertEqual(expectedSearchResult.count, 1)
        
        // Given a search text verify 2 instances are matched
        viewModel.searchText = "Di"
        let expectedSearchResult1 = Response.mockPokemons.filter { $0.name.localizedCaseInsensitiveContains(viewModel.searchText)}
        let actualSearchResult1 = viewModel.searchResults.filter { $0.name.localizedCaseInsensitiveContains(viewModel.searchText)}
        XCTAssertEqual(expectedSearchResult1, actualSearchResult1)
        XCTAssertEqual(expectedSearchResult1.count, 2)
        
        // Given a non valid search text verify empty array is returned
        viewModel.searchText = "Abc"
        let actualSearchResult2 = viewModel.searchResults.filter { $0.name.localizedCaseInsensitiveContains(viewModel.searchText)}
        XCTAssertTrue(actualSearchResult2.isEmpty)
    }
    
    func testGetPokemons_returns_validData() throws {
        let expectation = XCTestExpectation(description: "Get pokemon list")
        viewModel.getPokemonList {
            expectation.fulfill()
        }
        wait(for: [expectation])
        XCTAssertTrue(self.viewModel.pokemons.count == 5)
        XCTAssertEqual(self.viewModel.pokemons[0].name, "Pikachu")
    }
}

