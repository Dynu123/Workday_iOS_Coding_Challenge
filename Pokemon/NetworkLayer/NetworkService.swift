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
    func execute<T: Codable>(_ urlRequest: URLRequestBuilder, model: T.Type, completion: @escaping (Result<T, AFError>) -> Void) -> AnyCancellable
}

// MARK: - Extend NetworkServiceProtocol to implement the method
extension NetworkServiceProtocol {
    func execute<T: Codable>(_ urlRequest: URLRequestBuilder, model: T.Type, completion: @escaping (Result<T, AFError>) -> Void) -> AnyCancellable {
        
        let requestPublisher = AF.request(urlRequest).publishDecodable(type: T.self)
        
        let cancellable = requestPublisher
            .subscribe(on: DispatchQueue(label: "Background Queue", qos: .background))
            .receive(on: RunLoop.main)
            .sink { (response) in
                if let value = response.value {
                    completion(Result.success(value))
                } else if let error = response.error {
                    completion(Result.failure(error))
                }
            }
        return cancellable
    }
}

public class NetworkService: NetworkServiceProtocol {
    static let `default`: NetworkServiceProtocol = {
        var service = NetworkService()
        return service
    }()
}
