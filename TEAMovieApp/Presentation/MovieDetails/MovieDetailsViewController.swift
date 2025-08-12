//
//  MovieDetailsViewController.swift
//  TEAMovieApp
//
//  Created by Mohamed abdelhamed on 11/08/2025.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var backdropPathImageView: UIImageView!
    @IBOutlet weak var posterPathImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var favoritesButton: UIButton!
    @IBOutlet weak var overviewTextView: GrowingTextView!
    @IBOutlet weak var voteAverageLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    
    private let viewModel: MovieDetailsViewModelProtocol

    init(viewModel: MovieDetailsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Movie Details"
        configureUI(model: viewModel.movie)
    }
    
    @IBAction func favoritesButtonTap(_ sender: Any) {
        viewModel.movieIsFavButtonTapped(movieId: viewModel.movie.id)
        configureUI(model: viewModel.movie)
    }

}

extension MovieDetailsViewController {
    func configureUI(model: Movie) {
        posterPathImageView.setWith(model.fullPosterPath)
        backdropPathImageView.setWith(model.fullBackdropPath)
        nameLabel.text = model.title
        ratingLabel.text = String(model.voteAverage)
        dateLabel.text = model.releaseDate
        favoritesButton.isSelected = model.isFavorite
        favoritesButton.tintColor = model.isFavorite ? .red : .gray
        overviewTextView.text = model.overview
        voteAverageLabel.text = String(model.voteCount) + "votes"
        languageLabel.text = model.originalLanguage
    }
}
