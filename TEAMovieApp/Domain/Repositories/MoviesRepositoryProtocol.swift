//
//  MoviesRepositoryProtocol.swift
//  TEAMovieApp
//
//  Created by Mohamed abdelhamed on 10/08/2025.
//

import Combine

protocol MoviesRepositoryProtocol {
    func fetchMovies(page: Int) -> AnyPublisher<[MovieDTO], AppError>
    func saveMoviesDataBase(data: [MovieDTO]) -> AnyPublisher<[Movie], AppError>
    func fetchFromDatabaseMovies(page: Int, limit: Int) -> AnyPublisher<[Movie], AppError>
    func updateFavoriteStatus(movieId: Int, isFavorite: Bool) -> AnyPublisher<Void, AppError>
    func totalMoviesInDB() -> Int
}

