//
//  ErrorView.swift
//  Pokemon
//
//  Created by Dyana Arackal Varghese on 22/08/2024.
//

import SwiftUI

// MARK: - The Error View
struct ErrorView: View {
    let error       : ErrorType
    var action      : (() -> Void)?
    
    var body: some View {
        VStack {
            Text("Something went wrong")
                .font(.title2)
                .padding()
            Group {
                switch error {
                case .empty:
                    Text("No content found")
                case .decoding:
                    Text("Please contact developer")
                case .noInternet:
                    Text("Please check your internet connection")
                case .backend(let code):
                    switch code {
                    default:
                        Text("Server error code: \(code)")
                    }
                }
            }
            .padding()
            Button("Try again", action: action ?? {})
                .padding(10)
                .background(Color.blue)
                .foregroundStyle(.white)
                .clipShape(.capsule)
        }
    }
}

#Preview {
    ErrorView(error: .decoding, action: nil)
}
