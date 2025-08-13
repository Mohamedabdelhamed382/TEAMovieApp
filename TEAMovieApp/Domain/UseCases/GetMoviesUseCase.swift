//
//  GetMoviesUseCase.swift
//  TEAMovieApp
//
//  Created by Mohamed abdelhamed on 10/08/2025.
//

import Combine
import Foundation

protocol GetMoviesUseCaseProtocol {
    func execute(page: Int) -> AnyPublisher<[Movie], AppError>
    func updateFavoriteStatus(movieId: Int, isFavorite: Bool) -> AnyPublisher<Void, AppError>
}

final class GetMoviesUseCase: GetMoviesUseCaseProtocol {
    
    private let repository: MoviesRepositoryProtocol
    private let networkMonitor: NetworkMonitorProtocol
    private let pageLimit: Int
    
    init(repository: MoviesRepositoryProtocol,
         networkMonitor: NetworkMonitorProtocol = NetworkMonitor.shared,
         pageLimit: Int = 20) {
        self.repository = repository
        self.networkMonitor = networkMonitor
        self.pageLimit = pageLimit
    }
    
    func execute(page: Int) -> AnyPublisher<[Movie], AppError> {
        repository.fetchFromDatabaseMovies(page: page, limit: pageLimit)
            .flatMap { [weak self] cached -> AnyPublisher<[Movie], AppError> in
                guard let self = self else {
                    return Just([]).setFailureType(to: AppError.self).eraseToAnyPublisher()
                }
                
                print("📂 Cached movies count: \(cached.count)")
                
                if !cached.isEmpty {
                    return Just(cached).setFailureType(to: AppError.self).eraseToAnyPublisher()
                }
                
                if self.networkMonitor.isConnected {
                    print("🌍 Fetching from API...")
                    return self.repository.fetchMovies(page: page)
                        .flatMap { apiMovies -> AnyPublisher<[Movie], AppError> in
                            self.repository.saveMoviesDataBase(data: apiMovies)
                                .mapError { $0 as AppError }
                                .eraseToAnyPublisher()
                        }
                        .eraseToAnyPublisher()
                }
                
                print("📴 No internet, returning cached data (empty).")
                return Just(cached).setFailureType(to: AppError.self).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func updateFavoriteStatus(movieId: Int, isFavorite: Bool) -> AnyPublisher<Void, AppError> {
        repository.updateFavoriteStatus(movieId: movieId, isFavorite: isFavorite)
    }
}
