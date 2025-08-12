//
//  MovieDetailsViewModelProtocol.swift
//  TEAMovieApp
//
//  Created by Mohamed abdelhamed on 11/08/2025.
//

protocol MovieDetailsViewModelProtocol: AnyObject {
    var movie: Movie { get }
    func movieIsFavButtonTapped(movieId: Int)
}
