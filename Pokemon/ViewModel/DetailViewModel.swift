//
//  DetailViewModel.swift
//  Pokemon
//
//  Created by Dyana Arackal Varghese on 17/08/2024.
//

import Foundation
import Combine
import Alamofire

class DetailViewModel: ObservableObject {
    @Published var pokemonDetail    = PokemonDetail.mockPokemonDetail
    @Published var viewState        : ViewState<PokemonDetail> = .loading
    @Published var showAlert        : Bool = false
    @Published var loadingError     : String = ""
    private var networkService      : NetworkServiceProtocol
    private var cancellableSet      : Set<AnyCancellable> = []
    
    // MARK: - Initialise Network Service
    init(networkService: NetworkServiceProtocol = NetworkService.default) {
        self.networkService = networkService
    }
    
    // MARK: - A method that will return the complete URL for the 'Type image' by fetching the 'ID' of the pokemon type
    func typeUrl(type: Species) -> String {
        guard let url = URL(string: type.url) else { return ""}
        let id = url.lastPathComponent
        return "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/types/generation-vi/x-y/\(id).png"
    }
    
    // MARK: - Fetch details of the pokemon selected
    func getPokemonDetails(pokemon: Pokemon, handler: @escaping () -> Void) {
        viewState = .loading
        guard let url = URL(string: pokemon.url) else { return }
        let id = url.lastPathComponent
        
        self.networkService.execute(API.getPokemonDetail(id: id), model: PokemonDetail.self)
            .sink(receiveCompletion: { [weak self] completion in
                handler()
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
                self.pokemonDetail = response
                
            }).store(in: &cancellableSet)
    }
}
