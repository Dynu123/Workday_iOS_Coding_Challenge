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
    @Published var pokemons     : [Pokemon] = []
    @Published var searchText   = ""
    private var networkService  : NetworkServiceProtocol
    private var cancellableSet  : Set<AnyCancellable> = []
    var offset                  = 0
    @Published var viewState    : ViewState<Response> = .loading
    
    // MARK: - To implement search in the pokemon list
    var searchResults: [Pokemon] {
        if searchText.isEmpty {
            return pokemons
        } else {
            return pokemons.filter { $0.name.localizedCaseInsensitiveContains(searchText)}
        }
    }
    
    // MARK: - Initialize network service and load the pokemons
    init(networkService: NetworkServiceProtocol = NetworkService.default) {
        self.networkService = networkService
        self.getPokemonList {}
    }
    
    // MARK: - API call for fetching Pokemon list
    func getPokemonList(handler: @escaping () -> Void) {
        viewState = .loading
        self.networkService.execute(API.getPokemons(offset: offset), model: Response.self)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .failure(let error):
                    if let code = error.responseCode {
                        self.viewState = .failure(.backend(code))
                    }
                    if error.isSessionTaskError {
                        self.viewState = .failure(.noInternet)
                    }
                    if error.isResponseSerializationError {
                        self.viewState = .failure(.decoding)
                    }
                case .finished:
                    break
                }
                handler()
            }, receiveValue: { [weak self] response in
                guard let self = self else { return }
                guard !response.results.isEmpty else { return self.viewState = .failure(.empty) }
                self.viewState = .success(response)
                self.pokemons = response.results
                handler()
            }).store(in: &cancellableSet)
    }
    
    // MARK: - Retrieves the next set of pokemon objects - implements pagination
    func getNextSetOfPokemonList() {
        offset += 20
        self.networkService.execute(API.getPokemons(offset: offset), model: Response.self)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .failure(let error):
                    if let code = error.responseCode {
                        self.viewState = .failure(.backend(code))
                    }
                    if error.isSessionTaskError {
                        self.viewState = .failure(.noInternet)
                    }
                    if error.isResponseSerializationError {
                        self.viewState = .failure(.decoding)
                    }
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] response in
                guard let self = self else { return }
                self.viewState = .success(response)
                self.pokemons += response.results
                guard !self.pokemons.isEmpty else { return self.viewState = .failure(.empty) }
            }).store(in: &cancellableSet)
    }
    
    // MARK: - A Check to load next set of pokemon when users reach end of pokemon list
    func hasReachedEnd(of pokemon: Pokemon) -> Bool {
        pokemons.last?.name == pokemon.name
    }
}
