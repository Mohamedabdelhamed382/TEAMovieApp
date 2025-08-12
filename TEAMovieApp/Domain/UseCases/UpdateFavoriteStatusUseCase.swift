//
//  UpdateFavoriteStatusUseCaseProtocol.swift
//  TEAMovieApp
//
//  Created by Mohamed abdelhamed on 12/08/2025.
//


import Combine

protocol UpdateFavoriteStatusUseCaseProtocol {
    func execute(movieId: Int, isFavorite: Bool) -> AnyPublisher<Void, AppError>
}

final class UpdateFavoriteStatusUseCase: UpdateFavoriteStatusUseCaseProtocol {
    private let repository: MoviesRepositoryProtocol
    
    init(repository: MoviesRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(movieId: Int, isFavorite: Bool) -> AnyPublisher<Void, AppError> {
        repository.updateFavoriteStatus(movieId: movieId, isFavorite: isFavorite)
    }
}
