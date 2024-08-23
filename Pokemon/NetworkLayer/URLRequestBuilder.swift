//
//  URLRequestBuilder.swift
//  Pokemon
//
//  Created by Dyana Arackal Varghese on 17/08/2024.
//

import Foundation
import Alamofire

// MARK: - Define protocol which conforms with URLRequestConvertible in Alamofire
protocol URLRequestBuilder: URLRequestConvertible {
    var baseURL: URL { get }
    var requestURL: URL { get }
    var path: String { get }
    var parameters: Parameters? { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders { get }
    var encoding: ParameterEncoding { get }
    var urlRequest: URLRequest { get }
    var queryItems: [String: Int]? { get }
}

// MARK: - Extend protocol to define each input
extension URLRequestBuilder {
    var baseURL: URL {
        return URL(string: AppEnvironment.baseUrl)!
    }
    
    var requestURL: URL {
        return baseURL.appendingPathComponent(path, isDirectory: false)
    }
    
    var encoding: ParameterEncoding {
        switch method {
        case .get:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
    
    var urlRequest: URLRequest {
        var request = URLRequest(url: requestURL)
        request.httpMethod = method.rawValue
        headers.forEach {
            request.addValue($0.value, forHTTPHeaderField: $0.name)
        }
        let requestQueryItem = queryItems?.compactMap { item in
            URLQueryItem(name: item.key , value: String(item.value))
        }
        guard let queryItem = requestQueryItem else { return  request }
        request.url?.append(queryItems: queryItem)
        return request
    }
    
    public func asURLRequest() throws -> URLRequest {
        return try encoding.encode(urlRequest, with: parameters)
    }
}
