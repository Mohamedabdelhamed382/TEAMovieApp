//
//  AppCoordinator.swift
//  TEAMovieApp
//
//  Created by Mohamed abdelhamed on 10/08/2025.
//

import UIKit

final class AppCoordinator: Coordinator {
    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let moviesCoordinator = MoviesCoordinator(navigationController: navigationController)
        moviesCoordinator.start()
    }
}
