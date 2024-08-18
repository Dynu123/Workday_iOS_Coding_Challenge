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
    private var bag: [AnyCancellable] = []
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func typeUrl(type: PokemonType) -> String {
        guard let url = URL(string: type.url) else { return ""}
        let id = url.lastPathComponent
        return "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/types/generation-vi/x-y/\(id).png"
    }
    
    
    func getPokemonDetails(pokemon: Pokemon, completion: @escaping () -> Void) {
        guard let url = URL(string: pokemon.url) else { return }
        let id = url.lastPathComponent
        
        self.networkService.execute(API.getPokemonDetail(id: id), model: PokemonDetail.self) { [weak self] (result: Result<PokemonDetail, AFError>) in
            guard let self = self else { return }
            switch result {
            case .success(let pokemonDetail):
                self.pokemonDetail = pokemonDetail
                completion() // for test case
            case .failure(let error):
                if let err = error as AFError? {
                    print(err.localizedDescription)
                }
                completion()// for test case
            }
        }
    }
}
