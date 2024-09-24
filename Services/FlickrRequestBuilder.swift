//
//  FlickrRequestBuilder.swift
//  FlickrCodeChallenge
//
//  Created by Abby Ke on 9/23/24.
//

import Foundation

struct FlickrRequestBuilder: RequestBuilder {
    
    var baseUrl: String { Constants.flickrBaseURL }
    var path: String? { nil }
    var method: HTTPMethod { .get }
    var tags: [String]
    var page: Int? // Add page parameter

    var queryParam: [String: String]? {
        var params = ["format": Constants.APIParameters.format,
                      "nojsoncallback": Constants.APIParameters.noJSONCallback, "tags": tags.joined(separator: ",")]

        return params
    }

    init(tags: [String], page: Int? = nil) {
        self.tags = tags
    }

    func buildRequest() throws -> URLRequest {
        guard var urlComponents = URLComponents(string: baseUrl) else {
            throw AppError.badURL
        }

        if let path = path {
            urlComponents.path = urlComponents.path.appending(path)
        }

        if let queryParam = queryParam {
            let encodedQuery = encodeParam(queryParam)
            urlComponents.query = encodedQuery
        }

        guard let url = urlComponents.url else {
            throw AppError.badURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        if let headers = headers {
            for (key, value) in headers {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }

        if let bodyParam = bodyParam {
            request.httpBody = try JSONSerialization.data(withJSONObject: bodyParam)
            request.addValue(Constants.APIHeaders.contentType, forHTTPHeaderField: "Content-Type")
        }

        return request
    }

    private func encodeParam(_ params: [String: String]) -> String? {
        var components = URLComponents()
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
        return components.percentEncodedQuery
    }
}
