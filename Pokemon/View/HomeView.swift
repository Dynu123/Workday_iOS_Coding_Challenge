//
//  ContentView.swift
//  Pokemon
//
//  Created by Dyana Arackal Varghese on 17/08/2024.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var homeViewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack {
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
                .navigationTitle("Pokemon")
            case .empty:
                ZStack {
                    Text("No data found")
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
                .background(.gray).opacity(0.7)
            default:
                EmptyView()
            }
        }
        .accentColor(.black)
        .alert(isPresented: $homeViewModel.showAlert) {
            Alert(title: Text("Error"), message: Text(homeViewModel.loadingError), primaryButton: .default(Text("Retry"),action:homeViewModel.getPokemonList), secondaryButton: .cancel())
         
            
        }
    }
}

#Preview {
    ContentView()
}
