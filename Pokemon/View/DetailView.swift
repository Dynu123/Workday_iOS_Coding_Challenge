//
//  DetailView.swift
//  Pokemon
//
//  Created by Dyana Arackal Varghese on 17/08/2024.
//

import SwiftUI
import Charts

// MARK: - The detail view
struct DetailView: View {
    @State var pokemon                          : Pokemon
    @StateObject private var detailViewModel    = DetailViewModel()
    
    var body: some View {
        ZStack {
            switch detailViewModel.viewState {
            case .loading:
                ProgressView()
            case .success:
                ScrollView {
                    VStack(spacing:20) {
                        VStack(spacing: 10) {
                            Text(detailViewModel.pokemonDetail.name.uppercased()).font(.title).padding(.top)
                            HStack{
                                ForEach(detailViewModel.pokemonDetail.types, id: \.slot) { type in
                                    AsyncImage(url: URL(string: detailViewModel.typeUrl(type: type.type))){ image in
                                        image.scaledToFit()
                                    } placeholder: {
                                        ProgressView()
                                    }
                                }
                            }
                            HStack(spacing: 20) {
                                Spacer()
                                VStack {
                                    Text("Id").font(.subheadline)
                                    Text(String(detailViewModel.pokemonDetail.id)).font(.headline)
                                }
                                
                                Divider()
                                
                                VStack {
                                    Text("Height").font(.subheadline)
                                    Text(String(detailViewModel.pokemonDetail.height)).font(.headline)
                                }
                                Divider()
                                VStack {
                                    Text("Weight").font(.subheadline)
                                    Text(String(detailViewModel.pokemonDetail.weight)).font(.headline)
                                }
                                Spacer()
                            }
                            .padding(.bottom)
                        }
                        .background(Color.yellow.opacity(0.1))
                        .border(.yellow)
                        HStack(spacing: 0) {
                            VStack(spacing: 8) {
                                Text("Front default")
                                AsyncImage(url: URL(string: detailViewModel.pokemonDetail.sprites.frontDefault)){ image in
                                    image.scaledToFit()
                                } placeholder: {
                                    ProgressView()
                                }
                                Divider().padding(.horizontal)
                                Text("Front shiny")
                                AsyncImage(url: URL(string: detailViewModel.pokemonDetail.sprites.frontShiny)){ image in
                                    image.scaledToFit()
                                } placeholder: {
                                    ProgressView()
                                }
                            }
                            .padding(.top)
                            Divider().padding(.vertical)
                            VStack(spacing: 8) {
                                Text("Back default")
                                AsyncImage(url: URL(string: detailViewModel.pokemonDetail.sprites.backDefault)){ image in
                                    image.scaledToFit()
                                } placeholder: {
                                    ProgressView()
                                }
                                Divider().padding(.horizontal)
                                Text("Back shiny")
                                AsyncImage(url: URL(string: detailViewModel.pokemonDetail.sprites.backShiny)){ image in
                                    image.scaledToFit()
                                } placeholder: {
                                    ProgressView()
                                }
                            }
                            .padding(.top)
                        }
                        .background(Color.yellow.opacity(0.1))
                        .border(.yellow)
                        VStack(spacing: 10) {
                            Text("Statistics").bold().padding()
                            HStack {
                                VStack(alignment: .leading) {
                                    ForEach(detailViewModel.pokemonDetail.stats, id: \.id) { stat in
                                        Text(stat.stat.name.capitalized).font(.subheadline)
                                    }
                                }
                                VStack(alignment: .leading) {
                                    ForEach(detailViewModel.pokemonDetail.stats, id: \.id) { stat in
                                        Text(":" + String(stat.baseStat)).font(.subheadline).bold()
                                    }
                                }
                            }
                            Chart {
                                ForEach(detailViewModel.pokemonDetail.stats, id: \.id) { stat in
                                    BarMark(
                                        x: .value("Stat name", stat.stat.name.capitalized),
                                        y: .value("base", stat.baseStat)
                                    )
                                    .foregroundStyle(.yellow)
                                }
                            }
                            .frame(height: 500)
                        }
                        .padding()
                        .background(Color.yellow.opacity(0.1))
                        .border(.yellow)
                    }
                    .padding()
                }
            case .failure(let errorType):
                ErrorView(error: errorType) {
                    detailViewModel.getPokemonDetails(pokemon: pokemon) {}
                }
            }
        }
        .onAppear {
            detailViewModel.getPokemonDetails(pokemon: pokemon) {}
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    DetailView(pokemon: Response.mockPokemons.first!)
}
