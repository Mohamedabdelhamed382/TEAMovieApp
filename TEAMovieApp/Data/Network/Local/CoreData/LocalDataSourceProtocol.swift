//
//  LocalDataSourceProtocol.swift
//  TEAMovieApp
//
//  Created by Mohamed abdelhamed on 11/08/2025.
//


protocol LocalDataSourceProtocol {
    func moviesDataSource() -> MoviesDataSource
}

final public class LocalStorage: LocalDataSourceProtocol {
    
    private let coreDataStorage: CoreDataStorage
    
    public init(coreDataStorage: CoreDataStorage) {
        self.coreDataStorage = coreDataStorage
    }
    
    func moviesDataSource() -> any MoviesDataSource {
        let store: PersistenceStore<MovieEntity> = PersistenceStore(coreDataStorage.persistentContainer)
        return CoreDataMoviesStorage(store: store)
    }
}
