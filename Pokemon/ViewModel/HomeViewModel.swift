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
    @Published var pokemons: [Pokemon] = []
    @Published var searchText = ""
    private var networkService: NetworkServiceProtocol
    private var cancellableSet: Set<AnyCancellable> = []
    var offset = 0
    @Published var viewState: ViewState?
    @Published var showAlert: Bool = false
    @Published var loadingError: String = ""
    
    
    init(networkService: NetworkServiceProtocol = NetworkService.default) {
        self.networkService = networkService
        getPokemonList()
    }
    
    var searchResults: [Pokemon] {
        if searchText.isEmpty {
            return pokemons
        } else {
            return pokemons.filter { $0.name.localizedCaseInsensitiveContains(searchText)}
        }
    }
    
    func getPokemonList() {
        viewState = .loading
        self.networkService.execute(API.getPokemons(offset: offset), model: Response.self)
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    self.viewState = .failure
                    self.createAlert(with: dataResponse.error!)
                } else {
                    self.viewState = .success
                    guard let results = dataResponse.value?.results else { return }
                    self.pokemons = results
                    if self.pokemons.isEmpty {
                        self.viewState = .empty
                    }
                }
            }.store(in: &cancellableSet)
    }
    
    func getNextSetOfPokemonList() {
        offset += 20
        //viewState = .loading
        self.networkService.execute(API.getPokemons(offset: offset), model: Response.self)
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    self.viewState = .failure
                    self.createAlert(with: dataResponse.error!)
                } else {
                    self.viewState = .success
                    guard let results = dataResponse.value?.results else { return }
                    self.pokemons += results
                    if self.pokemons.isEmpty {
                        self.viewState = .empty
                    }
                }
            }.store(in: &cancellableSet)
    }
    
    func hasReachedEnd(of pokemon: Pokemon) -> Bool {
        pokemons.last?.name == pokemon.name
    }
    
    func createAlert( with error: NetworkError ) {
        loadingError = error.backendError == nil ? error.initialError.localizedDescription : error.backendError!.message
        self.showAlert = true
    }
}

enum ViewState {
    case loading
    case success
    case failure
    case empty
}
