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
    @Published var pokemonDetail = PokemonDetail.sample
    private var networkService: NetworkServiceProtocol
    private var cancellableSet: Set<AnyCancellable> = []
    @Published var viewState: ViewState?
    @Published var showAlert: Bool = false
    @Published var loadingError: String = ""
    
    init(networkService: NetworkServiceProtocol = NetworkService.default) {
        self.networkService = networkService
    }
    
    func typeUrl(type: Species) -> String {
        guard let url = URL(string: type.url) else { return ""}
        let id = url.lastPathComponent
        return "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/types/generation-vi/x-y/\(id).png"
    }
    
    
    func getPokemonDetails(pokemon: Pokemon) {
        viewState = .loading
        guard let url = URL(string: pokemon.url) else { return }
        let id = url.lastPathComponent
        
        self.networkService.execute(API.getPokemonDetail(id: id), model: PokemonDetail.self)
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    self.viewState = .failure
                    self.createAlert(with: dataResponse.error!)
                } else {
                    self.viewState = .success
                    guard let detail = dataResponse.value else { return }
                    self.pokemonDetail = detail
                }
            }.store(in: &cancellableSet)
        
        
    }
    
    func createAlert( with error: NetworkError ) {
        loadingError = error.backendError == nil ? error.initialError.localizedDescription : error.backendError!.message
        self.showAlert = true
    }
}
