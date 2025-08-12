//
//  CoreDataStorage.swift
//  TEAMovieApp
//
//  Created by Mohamed abdelhamed on 11/08/2025.
//



import CoreData

public final class CoreDataStorage {
    
    public static let shared = CoreDataStorage()
    
    private init() { }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TEAMovieApp")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                assertionFailure("CoreDataStorage Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
}
