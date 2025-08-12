//
//  MoviesListCollectionViewCell.swift
//  TEAMovieApp
//
//  Created by Mohamed abdelhamed on 10/08/2025.
//

import UIKit
import Kingfisher

protocol MoviesListCollectionViewCellDelegate: AnyObject {
    func movieIsFavButton(movieId: Int, indexPath: IndexPath)
}

class MoviesListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieRatingLabel: UILabel!
    @IBOutlet weak var movieIsFavButton: UIButton!
    
    weak private var delegate: MoviesListCollectionViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        movieImageView.contentMode = .scaleAspectFill
        movieImageView.clipsToBounds = true
        movieImageView.layer.cornerRadius = 8
    }
    
    func configure(with movie: Movie, delegate: MoviesListCollectionViewCellDelegate?, indexPath: IndexPath) {
        movieTitleLabel.text = movie.title
        movieRatingLabel.text = "\(movie.voteAverage)"
        movieIsFavButton.isSelected = movie.isFavorite
        movieIsFavButton.tintColor = movie.isFavorite ? .red : .gray
        if let posterPath = movie.fullPosterPath {
            movieImageView.setWith(posterPath)
        }
        movieIsFavButton.addTapGesture { [weak self] in
            guard self != nil else { return }
            delegate?.movieIsFavButton(movieId: movie.id, indexPath: indexPath)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        movieImageView.image = nil
        movieTitleLabel.text = nil
        movieRatingLabel.text = nil
    }
}
