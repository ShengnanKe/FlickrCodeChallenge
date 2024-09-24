//
//  HttpClient.swift
//  FlickrCodeChallenge
//
//  Created by Abby Ke on 9/23/24.
//

import Foundation
import Combine
import SwiftUI

enum AppError: Error {
    case badURL
    case badResponse
    case badData
    case decoderError
    case serverError(Error?)
}

enum HTTPMethod: String {
    case get = "GET"
}

protocol RequestBuilder {
    var baseUrl: String { get }
    var path: String? { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var queryParam: [String: String]? { get }
    var bodyParam: [String: Any]? { get }
    
    func buildRequest() throws -> URLRequest
}

extension RequestBuilder {
    var baseUrl: String { "" }
    var headers: [String: String]? { nil }
    var queryParam: [String: String]? { nil }
    var bodyParam: [String: Any]? { nil }
    
    func buildRequest() throws -> URLRequest {
        // Get the url components
        guard var urlComponents = URLComponents(string: baseUrl) else {
            throw AppError.badURL
        }
        
        // Adding path to url component
        if let path = path {
            urlComponents.path = urlComponents.path.appending(path)
        }
        
        // Add query param
        if let queryParam = queryParam {
            let encodedQuery = encodeParam(queryParam)
            urlComponents.query = encodedQuery
        }
        
        guard let url = urlComponents.url else {
            throw AppError.badURL
        }
        
        // Method type
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        // Adding Headers
        if let headers = headers {
            for (key, value) in headers {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        // Add body params
        if let bodyParam = bodyParam {
            request.httpBody = try JSONSerialization.data(withJSONObject: bodyParam)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        return request
    }
    
    private func encodeParam(_ params: [String: String]) -> String? {
        var components = URLComponents()
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
        return components.percentEncodedQuery
    }
}

class HttpClient {
    
    func fetch<T: Decodable>(requestBuilder: RequestBuilder) -> AnyPublisher<T, Error> {
        do {
            let request = try requestBuilder.buildRequest()
            return URLSession.shared.dataTaskPublisher(for: request)
                .tryMap { output in
                    guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                        throw URLError(.badServerResponse)
                    }
                    return output.data
                }
                .decode(type: T.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
    
    func downloadImage(from url: URL) async -> UIImage? {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let uiImage = UIImage(data: data) {
                return uiImage
            } else {
                print(Constants.ErrorMessages.FailToConvertImage)
                return nil
            }
        } catch {
            print(Constants.ErrorMessages.FailToDownloadImage)
            return nil
        }
    }
}
