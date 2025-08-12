//
//  NetworkService.swift
//  TEAMovieApp
//
//  Created by Mohamed abdelhamed on 10/08/2025.
//

import Foundation
import Combine

protocol NetworkServiceProtocol {
    func request<T: Decodable>(_ endpoint: Endpoint, type: T.Type) -> AnyPublisher<T, APIError>
}

final class NetworkService: NetworkServiceProtocol {
    private let urlSession: URLSession
    private let decoder: JSONDecoder

    init(urlSession: URLSession = .shared, decoder: JSONDecoder = JSONDecoder()) {
        self.urlSession = urlSession
        self.decoder = decoder
    }

    func request<T: Decodable>(_ endpoint: Endpoint, type: T.Type) -> AnyPublisher<T, APIError> {
        guard let url = endpoint.url() else {
            return Fail(error: .invalidURL).eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        request.httpBody = endpoint.body

        // 🖨 Print Request Info
        print("🚀 [REQUEST]")
        print("URL: \(request.url?.absoluteString ?? "")")
        print("Method: \(request.httpMethod ?? "")")
        if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
            print("Headers: \(headers)")
        }
        if let body = request.httpBody,
           let bodyString = String(data: body, encoding: .utf8) {
            print("Body: \(bodyString)")
        }

        return urlSession.dataTaskPublisher(for: request)
            .tryMap { output in
                if let httpResponse = output.response as? HTTPURLResponse {
                    print("📩 [RESPONSE] Status Code: \(httpResponse.statusCode)")
                }

                // 🖨 Pretty Print JSON Response
                if let jsonObject = try? JSONSerialization.jsonObject(with: output.data, options: []),
                   let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
                   let prettyString = String(data: prettyData, encoding: .utf8) {
                    print("JSON Response:\n\(prettyString)")
                } else {
                    print("Raw Response:\n\(String(data: output.data, encoding: .utf8) ?? "N/A")")
                }

                if let httpResponse = output.response as? HTTPURLResponse,
                   !(200...299).contains(httpResponse.statusCode) {
                    throw APIError.serverError(httpResponse.statusCode)
                }

                return output.data
            }
            .decode(type: T.self, decoder: decoder)
            .mapError { error in
                print("❌ Network Error: \(error)")
                if let apiError = error as? APIError { return apiError }
                if error is DecodingError { return .decodingError(error) }
                return .networkError(error)
            }
            .eraseToAnyPublisher()
    }
}
