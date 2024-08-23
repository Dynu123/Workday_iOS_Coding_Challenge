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
    func execute<T: Codable>(_ urlRequest: URLRequestBuilder, model: T.Type) -> AnyPublisher<T, AFError>
}

extension NetworkServiceProtocol {
    func execute<T: Codable>(_ urlRequest: URLRequestBuilder, model: T.Type) -> AnyPublisher<T, AFError> {
        return AF.request(urlRequest)
        .validate()
        .publishDecodable(type: T.self)
        .value()
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
