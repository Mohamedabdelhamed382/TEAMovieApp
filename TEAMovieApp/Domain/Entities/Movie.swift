//
//  Movie.swift
//  TEAMovieApp
//
//  Created by Mohamed abdelhamed on 10/08/2025.
//

import Foundation

struct Movie: Identifiable, Hashable {
    let id: Int
    let title: String
    let posterPath: String?
    let backdropPath: String?
    let voteAverage: Double
    let releaseDate: String
    let originalLanguage: String
    let overview: String
    var isFavorite: Bool = false
    var voteCount: Int
    var cachedAt: Date?

    var fullPosterPath: String? {
        "https://image.tmdb.org/t/p/w500\(posterPath ?? "")"
    }
    var fullBackdropPath: String? {
        "https://image.tmdb.org/t/p/w500\(backdropPath ?? "")"
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Movie, rhs: Movie) -> Bool {
        lhs.id == rhs.id
    }
}


