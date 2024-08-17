//
//  ContentView.swift
//  Pokemon
//
//  Created by Dyana Arackal Varghese on 17/08/2024.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var homeViewModel = HomeViewModel(networkService: NetworkService())
    
    var body: some View {
        NavigationStack {
            List(homeViewModel.searchResults, id: \.self.name) { pokemon in
                NavigationLink {
                    DetailView(pokemon: pokemon)
                } label: {
                    Text(pokemon.name.capitalized)
                }
            }
            .navigationTitle("Pokemon")
        }
        .searchable(text: $homeViewModel.searchText)
        .onAppear(perform: {
            homeViewModel.getPokemonList {}
        })
    }
}

#Preview {
    ContentView()
}
