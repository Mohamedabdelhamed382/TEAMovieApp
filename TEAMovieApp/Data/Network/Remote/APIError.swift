//
//  APIError.swift
//  TEAMovieApp
//
//  Created by Mohamed abdelhamed on 10/08/2025.
//

import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case serverError(Int)

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .networkError(let e): return "Connection error: \(e.localizedDescription)"
        case .decodingError(let e): return "Data parsing error: \(e.localizedDescription)"
        case .serverError(let code): return "Server error with code \(code)"
        }
    }
}

enum DataBaseError: LocalizedError {
    case savingError
    case fetchError
    case deleteError
    case updateError

    var errorDescription: String? {
        switch self {
        case .savingError: return "savingError"
        case .fetchError: return "fetchError"
        case .deleteError: return "deleteError"
        case .updateError: return "updateError"
        }
    }
}

enum AppError: LocalizedError {
    case api(APIError)
    case database(DataBaseError)

    var errorDescription: String? {
        switch self {
        case .api(let e): return e.errorDescription
        case .database(let e): return e.errorDescription
        }
    }
}
