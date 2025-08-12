//
//  CoreDataStack.swift
//  TEAMovieApp
//
//  Created by Mohamed abdelhamed on 10/08/2025.
//

import Combine
import CoreData
import Foundation

extension PersistenceStore where Entity == MovieEntity {
    func insertMovies(_ movies: [MovieDTO]) {
        managedObjectContext.performChanges {
            for movieDTO in movies {
                // Check if movie already exists in Core Data
                if let existingMovie = MovieEntity.findOrFetch(
                    in: self.managedObjectContext,
                    matching: NSPredicate(format: "id == %d", movieDTO.id)
                ) {
                    // Update existing movie
                    existingMovie.title = movieDTO.title
                    existingMovie.posterPath = movieDTO.posterPath
                    existingMovie.backdropPath = movieDTO.backdropPath
                    existingMovie.voteAverage = movieDTO.voteAverage
                    existingMovie.releaseDate = movieDTO.releaseDate
                    existingMovie.originalLanguage = movieDTO.originalLanguage
                    existingMovie.overview = movieDTO.overview
                    existingMovie.isFavorite = movieDTO.isFavorite ?? false
                    existingMovie.voteCount = Int64(movieDTO.voteCount ?? 0)
                    existingMovie.cachedAt = Date()
                } else {
                    // Insert new movie
                    let movieEntity = MovieEntity.insert(into: self.managedObjectContext, value: movieDTO)
                    movieEntity.cachedAt = Date()
                }
            }
        }
    }
}
