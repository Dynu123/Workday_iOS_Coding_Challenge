//
//  HomeViewModel.swift
//  Pokemon
//
//  Created by Dyana Arackal Varghese on 17/08/2024.
//

import Foundation
import Combine
import Alamofire

class HomeViewModel: ObservableObject {
    @Published private var pokemons: [Pokemon] = []
    @Published var searchText = ""
    private var networkService: NetworkServiceProtocol
    private var bag: [AnyCancellable] = []
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    var searchResults: [Pokemon] {
        if searchText.isEmpty {
            return pokemons
        } else {
            return pokemons.filter { $0.name.localizedCaseInsensitiveContains(searchText)}
        }
    }
    
    func getPokemonList(completion: @escaping () -> Void) {
        self.networkService.execute(API.getPokemons, model: Response.self) { [weak self] (result: Result<Response, AFError>) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.pokemons = response.results
                print(self.pokemons)
                completion() // for test case
            case .failure(let error):
                if let err = error as AFError? {
                    print(err)
                }
                completion()// for test case
            }
        }
    }
}
