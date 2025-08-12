//
//  MoviesListViewModel.swift
//  TEAMovieApp
//
//  Created by Mohamed abdelhamed on 10/08/2025.
//

import Combine
import Foundation

final class MoviesListViewModel: MoviesListViewModelProtocol {
    @Published private(set) var movies: [Movie] = []
    @Published private(set) var errorMessage: String?
    
    var isLoading = false
    private var currentPage = 1
    private var canLoadMorePages = true
    
    var moviesPublisher: Published<[Movie]>.Publisher { $movies }
    var errorMessagePublisher: Published<String?>.Publisher { $errorMessage }
    var coordinator: MoviesCoordinator
    weak var delegateActionCell: MoviesListCollectionViewCellDelegate?
    
    private let getMoviesUseCase: GetMoviesUseCaseProtocol
    private var cancellable = Set<AnyCancellable>()

    init(getMoviesUseCase: GetMoviesUseCaseProtocol, coordinator: MoviesCoordinator) {
        self.getMoviesUseCase = getMoviesUseCase
        self.coordinator = coordinator
        delegateActionCell = self
    }

    func loadMovies(page: Int = 1) {
        guard !isLoading, canLoadMorePages else { return }
        
        isLoading = true
        print("🔄 Loading movies for page: \(page)")
        
        getMoviesUseCase.execute(page: page)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                
                if case .failure(let error) = completion {
                    print("❌ Error loading movies: \(error.localizedDescription)")
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] newMovies in
                guard let self = self else { return }
                print("✅ Received \(newMovies.count) movies")
                
                if newMovies.isEmpty {
                    self.canLoadMorePages = false
                } else {
                    if page == 1 {
                        self.movies = newMovies
                    } else {
                        self.movies.append(contentsOf: newMovies)
                    }
                    self.currentPage = page
                }
            }
            .store(in: &cancellable)
    }
    
    func loadNextPage() {
        loadMovies(page: currentPage + 1)
    }
    
    func selectedMovie(index: Int) {
        let movie = movies[index]
        coordinator.gotoMovieDetails(movie: movie) { [weak self] updatedMovie in
            guard let self = self else { return }
            if let idx = self.movies.firstIndex(where: { $0.id == updatedMovie.id }) {
                self.movies[idx] = updatedMovie
            }
        }
    }
}

extension MoviesListViewModel: MoviesListCollectionViewCellDelegate {
    func movieIsFavButton(movieId: Int, indexPath: IndexPath) {
        print("movieId: ", "\(movieId)", "indexPath: ", "\(indexPath)")
        var movie = movies[indexPath.item]
            movie.isFavorite.toggle() // عكس الحالة الحالية
            
            movies[indexPath.item] = movie
            
            getMoviesUseCase.updateFavoriteStatus(movieId: movieId, isFavorite: movie.isFavorite)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    if case .failure(let error) = completion {
                        print("❌ Failed to update favorite: \(error.localizedDescription)")
                    }
                } receiveValue: {
                    print("✅ Favorite status updated for movie \(movieId)")
                }
                .store(in: &cancellable)
        
    }
}
