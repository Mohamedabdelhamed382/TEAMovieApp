//
//  MoviesRepositoryImpl.swift
//  TEAMovieApp
//
//  Created by Mohamed abdelhamed on 10/08/2025.
//

import Combine
import Foundation
import CoreData

final class MoviesRepositoryImpl: MoviesRepositoryProtocol {
    
    private let networkService: NetworkServiceProtocol
    private let localDataSource: MoviesDataSource
    
    init(
        networkService: NetworkServiceProtocol,
        localDataSource: MoviesDataSource
    ) {
        self.networkService = networkService
        self.localDataSource = localDataSource
    }
    
    // MARK: - Fetch from API
    func fetchMovies(page: Int) -> AnyPublisher<[MovieDTO], AppError> {
        let endpoint = Endpoint(
            path: "/discover/movie",
            method: .get,
            queryItems: [
                URLQueryItem(name: "primary_release_year", value: "2025"),
                URLQueryItem(name: "sort_by", value: "popularity.desc"),
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "api_key", value: APIConstants.apiKey)
            ]
        )
        
        return networkService
            .request(endpoint, type: MoviesResponseDTO.self)
            .map { $0.results }
            .mapError { AppError.api($0) }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Save to DB
    func saveMoviesDataBase(data: [MovieDTO]) -> AnyPublisher<[Movie], AppError> {
        localDataSource
            .saveMovies(data)
            .mapError { AppError.database(($0 as? DataBaseError) ?? .savingError) }
            .map { _ in
                data.map { $0.toDomain() }
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Fetch from DB
    func fetchFromDatabaseMovies(page: Int, limit: Int) -> AnyPublisher<[Movie], AppError> {
        localDataSource.fetchFromDatabaseMovies(page: page, limit: limit)
            .mapError { AppError.database(($0 as DataBaseError)) }
            .eraseToAnyPublisher()
    }
    
    func updateFavoriteStatus(movieId: Int, isFavorite: Bool) -> AnyPublisher<Void, AppError> {
        localDataSource
            .updateFavoriteStatus(movieId: movieId, isFavorite: isFavorite)
            .mapError { AppError.database(($0 as DataBaseError)) }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Count
    func totalMoviesInDB() -> Int {
        return localDataSource.getMoviesCount()
    }
}
