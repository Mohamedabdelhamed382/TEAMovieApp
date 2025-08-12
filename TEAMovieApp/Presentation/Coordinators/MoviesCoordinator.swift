//
//  MoviesCoordinator.swift
//  TEAMovieApp
//
//  Created by Mohamed abdelhamed on 10/08/2025.
//

import UIKit

final class MoviesCoordinator: Coordinator {
    let navigationController: UINavigationController
    
    // نخزنهم عشان نقدر نستخدمهم في أي مكان
    private let repository: MoviesRepositoryProtocol
    private let getMoviesUseCase: GetMoviesUseCaseProtocol

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        // إنشاء الـ dependencies مرة واحدة
        let networkService = NetworkService()
        let localStorage = LocalStorage(coreDataStorage: CoreDataStorage.shared)
        let moviesDataSource = localStorage.moviesDataSource() as! CoreDataMoviesStorage
        let repo = MoviesRepositoryImpl(
            networkService: networkService,
            localDataSource: moviesDataSource
        )
        let useCase = GetMoviesUseCase(repository: repo)
        
        self.repository = repo
        self.getMoviesUseCase = useCase
    }

    func start() {
        let viewModel = MoviesListViewModel(getMoviesUseCase: getMoviesUseCase, coordinator: self)
        let moviesVC = MoviesListViewController(viewModel: viewModel)
        navigationController.pushViewController(moviesVC, animated: false)
    }
    
    func gotoMovieDetails(movie: Movie, onUpdate: @escaping (Movie) -> Void) {
        let updateFavUseCase = UpdateFavoriteStatusUseCase(repository: repository)
        let viewModel = MovieDetailsViewModel(movie: movie, updateFavoriteStatusUseCase: updateFavUseCase)
        viewModel.onMovieUpdated = onUpdate
        let moviesVC = MovieDetailsViewController(viewModel: viewModel)
        navigationController.pushViewController(moviesVC, animated: false)
    }
}
