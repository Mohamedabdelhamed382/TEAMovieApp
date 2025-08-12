//
//  MovieDataSource.swift
//  TEAMovieApp
//
//  Created by Mohamed abdelhamed on 11/08/2025.
//


import Combine
import Foundation
import CoreData

protocol MoviesDataSource {
    func saveMovies(_ movieDTO: [MovieDTO]) -> AnyPublisher<Void, Error>
}

final class CoreDataMoviesStorage {
    
    let store: PersistenceStore<MovieEntity>
    
    init(store: PersistenceStore<MovieEntity>) {
        self.store = store
    }
    
    deinit {
        print("\(Self.self) is deinit, No memory leak found")
    }
    
    func getMoviesCount() -> Int {
        return store.totalCount()
    }
}

extension CoreDataMoviesStorage: MoviesDataSource {
    func saveMovies(_ movieDTO: [MovieDTO]) -> AnyPublisher<Void, Error> {
        return Deferred { [store] in
            return Future<Void, Error> { promise in
                let backgroundContext = store.backgroundContext
                
                backgroundContext.perform {
                    do {
                        movieDTO.forEach { dto in
                            _ = dto.toCoreData(in: backgroundContext)
                        }
                        try backgroundContext.save()
                        
                        print("✅ Saved \(movieDTO.count) movies in background context")
                        print("📊 Number of movies in the database: \(self.getMoviesCount())")
                        promise(.success(()))
                    } catch {
                        print("❌ Core Data save failed: \(error.localizedDescription)")
                        promise(.failure(error))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func updateFavoriteStatus(movieId: Int, isFavorite: Bool) -> AnyPublisher<Void, DataBaseError> {
        Future { [weak self] promise in
            guard let self = self else {
                return promise(.failure(.updateError))
            }
            let context = self.store.managedObjectContext
            let request = NSFetchRequest<MovieEntity>(entityName: MovieEntity.entityName)
            request.predicate = NSPredicate(format: "id == %d", movieId)
            do {
                if let movieEntity = try context.fetch(request).first {
                    movieEntity.isFavorite = isFavorite
                    try context.save()
                    promise(.success(()))
                } else {
                    promise(.failure(.updateError))
                }
            } catch {
                promise(.failure(.updateError))
            }
        }
        .eraseToAnyPublisher()
    }

}
