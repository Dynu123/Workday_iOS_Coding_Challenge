//
//  DetailView.swift
//  Pokemon
//
//  Created by Dyana Arackal Varghese on 17/08/2024.
//

import SwiftUI

struct DetailView: View {
    
    @State var pokemon = Pokemon(id: UUID(), name: "", url: "")
    @StateObject private var detailViewModel = DetailViewModel(networkService: NetworkService())
    
    var body: some View {
        HStack {
            VStack {
                Text(detailViewModel.pokemonDetail.name.capitalized)
                Text(String(detailViewModel.pokemonDetail.height))
                Text(String(detailViewModel.pokemonDetail.weight))
                Text(String(detailViewModel.pokemonDetail.id))
                
            }
            Spacer()
        }
        .padding()
        .onAppear {
            detailViewModel.getPokemonDetails(pokemon: pokemon) {
                print(detailViewModel.pokemonDetail.height)
            }
        }
    }
}

#Preview {
    DetailView()
}
