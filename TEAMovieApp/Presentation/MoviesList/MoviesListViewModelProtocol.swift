//
//  MoviesListViewModelProtocol.swift
//  TEAMovieApp
//
//  Created by Mohamed abdelhamed on 10/08/2025.
//

import Combine

protocol MoviesListViewModelProtocol: AnyObject {
    var moviesPublisher: Published<[Movie]>.Publisher { get }
    var errorMessagePublisher: Published<String?>.Publisher { get }
    var delegateActionCell: MoviesListCollectionViewCellDelegate? {set get}
    var movies: [Movie] { get }
    var isLoading: Bool { get }
    
    func loadMovies(page: Int)
    func selectedMovie(index: Int)
    func loadNextPage()
}

