//
//  AppCoordinator.swift
//  TEAMovieApp
//
//  Created by Mohamed abdelhamed on 10/08/2025.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    let navigationController: UINavigationController
    let dependencies = MovieDIContainer()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let moviesCoordinator = MoviesCoordinator(navigationController: navigationController,
                                                  depend:  dependencies)
        moviesCoordinator.start()
    }
}
