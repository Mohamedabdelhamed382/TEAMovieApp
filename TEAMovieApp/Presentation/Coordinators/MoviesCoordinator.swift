//
//  MoviesCoordinator.swift
//  TEAMovieApp
//
//  Created by Mohamed abdelhamed on 10/08/2025.
//

import UIKit

final class MoviesCoordinator: Coordinator {
    
    let navigationController: UINavigationController
    private let depend: MovieDependancies

    init(navigationController: UINavigationController,
         depend: MovieDependancies
    ) {
        self.navigationController = navigationController
        self.depend = depend
    }

    func start() {
        let moviesVC = depend.buildMoviesListViewController(coordinator: self)
        navigationController.pushViewController(moviesVC, animated: false)
    }
    
    func gotoMovieDetails(movie: Movie, onUpdate: @escaping MovieHanlder) {
        let moviesVC = depend.buildMovieDetailsViewController(coordinator: self, movie: movie, onUpdate: onUpdate)
        navigationController.pushViewController(moviesVC, animated: false)
    }
}


