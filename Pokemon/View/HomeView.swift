//
//  ContentView.swift
//  Pokemon
//
//  Created by Dyana Arackal Varghese on 17/08/2024.
//

import SwiftUI

// MARK: - The main view
struct ContentView: View {
    
    @StateObject private var homeViewModel =  HomeViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                switch homeViewModel.viewState {
                case .loading:
                    ProgressView()
                case .success:
                    List(homeViewModel.searchResults, id: \.self.name) { pokemon in
                        NavigationLink {
                            DetailView(pokemon: pokemon)
                        } label: {
                            Text(pokemon.name.capitalized)
                                .task {
                                    if homeViewModel.hasReachedEnd(of: pokemon) {
                                        homeViewModel.getNextSetOfPokemonList()
                                    }
                                }
                        }
                    }
                    .listRowSpacing(10)
                    .searchable(text: $homeViewModel.searchText)
                case .failure(let errorType):
                    ErrorView(error: errorType) {
                        homeViewModel.getPokemonList {}
                    }
                }
            }
            .navigationTitle("Pokemon")
        }
        .accentColor(.black)
    }
}

#Preview {
    ContentView()
}

