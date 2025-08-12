//
//  MovieDetailsViewModel.swift
//  TEAMovieApp
//
//  Created by Mohamed abdelhamed on 11/08/2025.
//


import Combine

final class MovieDetailsViewModel: MovieDetailsViewModelProtocol {
    
    var movie: Movie
    var onMovieUpdated: ((Movie) -> Void)?
    private let updateFavoriteStatusUseCase: UpdateFavoriteStatusUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(movie: Movie, updateFavoriteStatusUseCase: UpdateFavoriteStatusUseCaseProtocol) {
        self.movie = movie
        self.updateFavoriteStatusUseCase = updateFavoriteStatusUseCase
    }
    
    func movieIsFavButtonTapped(movieId: Int) {
        movie.isFavorite.toggle()
        
        updateFavoriteStatusUseCase.execute(movieId: movieId, isFavorite: movie.isFavorite)
            .sink { completion in
                if case .failure(let error) = completion {
                    print("❌ Failed to update favorite: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] in
                guard let self = self else { return }
                print("✅ Favorite status updated for movie \(movieId)")
                self.onMovieUpdated?(self.movie) // نرسل التغيير للشاشة الأولى
            }
            .store(in: &cancellables)
    }
}
