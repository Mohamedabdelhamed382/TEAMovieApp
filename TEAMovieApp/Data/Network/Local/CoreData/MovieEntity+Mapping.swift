//
//  MovieEntity+Mapping.swift
//  TEAMovieApp
//
//  Created by Mohamed abdelhamed on 10/08/2025.
//

import CoreData

@objc(MovieEntity)
public class MovieEntity: NSManagedObject {
    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var posterPath: String?
    @NSManaged public var backdropPath: String?
    @NSManaged public var voteAverage: Double
    @NSManaged public var releaseDate: String?
    @NSManaged public var originalLanguage: String?
    @NSManaged public var overview: String?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var cachedAt: Date?
    @NSManaged public var voteCount: Int64
}

extension MovieEntity {
    func toDomain() -> Movie {
        return Movie(
            id: Int(self.id),
            title: self.title ?? "",
            posterPath: self.posterPath,
            backdropPath: backdropPath,
            voteAverage: self.voteAverage,
            releaseDate: self.releaseDate ?? "",
            originalLanguage: originalLanguage ?? "",
            overview: self.overview ?? "",
            isFavorite: self.isFavorite,
            voteCount: Int(voteCount)

        )
    }
}

extension MovieEntity: Managed {
    
    @discardableResult
    static func insert(into context: NSManagedObjectContext, value: MovieDTO) -> MovieEntity {
        return value.toCoreData(in: context)
    }
    
}

extension MovieDTO {
    func toCoreData(in context: NSManagedObjectContext) -> MovieEntity {
        let movieEntity = MovieEntity(context: context)
        movieEntity.id = Int64(id)
        movieEntity.title = title
        movieEntity.posterPath = posterPath
        movieEntity.backdropPath = backdropPath
        movieEntity.voteAverage = voteAverage
        movieEntity.releaseDate = releaseDate
        movieEntity.originalLanguage = originalLanguage
        movieEntity.overview = overview
        movieEntity.isFavorite = isFavorite ?? false
        movieEntity.voteCount = Int64(voteCount ?? 0)
        return movieEntity
    }
}
