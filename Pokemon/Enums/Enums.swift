//
//  Enums.swift
//  Pokemon
//
//  Created by Dyana Arackal Varghese on 22/08/2024.
//

import Foundation

// MARK: - State of the view
enum ViewState<T: Codable> {
    case loading
    case success(T)
    case failure(ErrorType)
}

// MARK: - Type of errors thrown after an api call
enum ErrorType {
    case decoding
    case noInternet
    case backend(Int)
    case empty
}
