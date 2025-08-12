//
//  Coordinator.swift
//  TEAMovieApp
//
//  Created by Mohamed abdelhamed on 10/08/2025.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get }
    func start()
}
