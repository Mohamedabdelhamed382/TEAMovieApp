//
//  MovieDTO.swift
//  TEAMovieApp
//
//  Created by Mohamed abdelhamed on 10/08/2025.
//

import Foundation

struct MoviesResponseDTO: Decodable {
    let page: Int
    let results: [MovieDTO]
    let totalPages: Int

    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
    }
}

struct MovieDTO: Decodable {
    let id: Int
    let title: String
    let posterPath: String?
    let backdropPath: String?
    let voteAverage: Double
    let releaseDate: String?
    let overview: String?
    let originalLanguage: String?
    let voteCount: Int?
    var isFavorite: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
        case originalLanguage = "original_language"
        case voteCount = "vote_count"

    }

    func toDomain() -> Movie {
        Movie(
            id: id,
            title: title,
            posterPath: posterPath,
            backdropPath: backdropPath,
            voteAverage: voteAverage,
            releaseDate: releaseDate ?? "",
            originalLanguage: originalLanguage ?? "",
            overview: overview ?? "",
            isFavorite: isFavorite ?? false,
            voteCount: voteCount ?? 0
        )
    }
}
