//
//  MovieDependancies.swift
//  TEAMovieApp
//
//  Created by Mohamed abdelhamed on 13/08/2025.
//


protocol MovieDependancies {
    func buildMoviesListViewController(coordinator: MoviesCoordinator) -> MoviesListViewController
    func buildMovieDetailsViewController(coordinator: MoviesCoordinator, movie: Movie, onUpdate: @escaping MovieHanlder) -> MovieDetailsViewController
}

class MovieDIContainer {

    let networkService = NetworkService()
    let localStorage = LocalStorage(coreDataStorage: CoreDataStorage.shared)
    
    private func makeMovieDataSource() -> MoviesDataSource {
        return localStorage.moviesDataSource()
    }
    
    lazy var repository: MoviesRepositoryImpl = {
        return .init(networkService: networkService, localDataSource: makeMovieDataSource())
    }()
    
    private func makeMoviceUseCase() -> GetMoviesUseCaseProtocol {
        return GetMoviesUseCase(repository: repository)
    }
    
    private func uppdateMoviceUseCase() -> UpdateFavoriteStatusUseCaseProtocol {
        return UpdateFavoriteStatusUseCase(repository: repository)
    }
}

extension MovieDIContainer: MovieDependancies {
    func buildMoviesListViewController(coordinator: MoviesCoordinator) -> MoviesListViewController {
        let viewModel = MoviesListViewModel(
            getMoviesUseCase: makeMoviceUseCase(),
            coordinator: coordinator
        )
        return MoviesListViewController(viewModel: viewModel)
    }
    
    func buildMovieDetailsViewController(coordinator: MoviesCoordinator, movie: Movie, onUpdate: @escaping MovieHanlder) -> MovieDetailsViewController {
        let viewModel = MovieDetailsViewModel(
            movie: movie,
            updateFavoriteStatusUseCase: uppdateMoviceUseCase()
        )
        viewModel.onMovieUpdated = onUpdate
        return MovieDetailsViewController(viewModel: viewModel)
    }
}

typealias MovieHanlder = (Movie) -> Void
