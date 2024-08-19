//
//  NetworkService.swift
//  Pokemon
//
//  Created by Dyana Arackal Varghese on 17/08/2024.
//

import Foundation
import Combine
import Alamofire


// MARK: - NetworkServiceProtocol to execute URLRequest
protocol NetworkServiceProtocol: AnyObject {
    func execute<T: Codable>(_ urlRequest: URLRequestBuilder, model: T.Type) -> AnyPublisher<DataResponse<T, NetworkError>, Never>
}

// MARK: - Extend NetworkServiceProtocol to implement the method
extension NetworkServiceProtocol {
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
            .eraseToAnyPublisher()
    }
}

public class NetworkService: NetworkServiceProtocol {
    static let `default`: NetworkServiceProtocol = {
        var service = NetworkService()
        return service
    }()
}




struct NetworkError: Error {
  let initialError: AFError
  let backendError: BackendError?
}

struct BackendError: Codable, Error {
    var status: String
    var message: String
}
