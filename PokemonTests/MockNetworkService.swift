//
//  MockNetworkService.swift
//  Pokemon
//
//  Created by Dyana Arackal Varghese on 19/08/2024.
//

import Foundation
import Combine
import Alamofire


// MARK: - Class for mocking NetworkServiceProtocol
class MockNetworkService: NetworkServiceProtocol {
    func execute<T: Codable>(_ urlRequest: URLRequestBuilder, model: T.Type) -> AnyPublisher<DataResponse<T, NetworkError>, Never> {
        
        
        
        return AF.request(urlRequest)
            .validate()
            .publishDecodable(type: T.self)
            .map { response in
                response.mapError { error in
                    let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0)}
                    return NetworkError(initialError: error, backendError: backendError)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher( )
       
        
    }
}
