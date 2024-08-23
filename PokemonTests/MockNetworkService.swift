//
//  MockNetworkService.swift
//  Pokemon
//
//  Created by Dyana Arackal Varghese on 19/08/2024.
//

import Foundation
import Combine
import Alamofire

 //MARK: - Class for mocking NetworkServiceProtocol
class MockNetworkService: NetworkServiceProtocol {
    func execute<T>(_ urlRequest: any URLRequestBuilder, model: T.Type) -> AnyPublisher<T, AFError> {
        if T.self == Response.self {
            return Just(Response.mockResponse as! T)
                            .setFailureType(to: AFError.self)
                            .eraseToAnyPublisher()
        } 
        else if T.self == PokemonDetail.self {
            return Just(PokemonDetail.mockPokemonDetail as! T)
                            .setFailureType(to: AFError.self)
                            .eraseToAnyPublisher()
        }
        return Fail(error: NSError() as! AFError).eraseToAnyPublisher()
    }
}
