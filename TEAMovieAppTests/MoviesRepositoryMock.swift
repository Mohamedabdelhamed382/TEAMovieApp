//
//  MoviesRepositoryMock.swift
//  TEAMovieApp
//
//  Created by Mohamed abdelhamed on 12/08/2025.
//


import Combine
@testable import TEAMovieApp

final class MoviesRepositoryMock: MoviesRepositoryProtocol {
    
    var cachedMovies: [Movie] = []
    var apiMovies: [MovieDTO] = []
    
    func fetchMovies(page: Int) -> AnyPublisher<[MovieDTO], AppError> {
        return Just(apiMovies)
            .setFailureType(to: AppError.self)
            .eraseToAnyPublisher()
    }
    
    func saveMoviesDataBase(data: [MovieDTO]) -> AnyPublisher<[Movie], AppError> {
        let domainMovies = data.map { $0.toDomain() }
        return Just(domainMovies)
            .setFailureType(to: AppError.self)
            .eraseToAnyPublisher()
    }
    
    func fetchFromDatabaseMovies(page: Int, limit: Int) -> AnyPublisher<[Movie], AppError> {
        return Just(cachedMovies)
            .setFailureType(to: AppError.self)
            .eraseToAnyPublisher()
    }
    
    func totalMoviesInDB() -> Int {
        return cachedMovies.count
    }
    
    func updateFavoriteStatus(movieId: Int, isFavorite: Bool) -> AnyPublisher<Void, AppError> {
        return Just(())
            .setFailureType(to: AppError.self)
            .eraseToAnyPublisher()
    }
}
