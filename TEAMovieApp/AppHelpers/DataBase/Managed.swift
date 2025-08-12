//
//  Managed.swift
//  TEAMovieApp
//
//  Created by Mohamed abdelhamed on 11/08/2025.
//

import CoreData

protocol Managed: NSFetchRequestResult {
    static var entityName: String { get }
    static var defaultSortDescriptors: [NSSortDescriptor] { get }
}

extension Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return []
    }
}

// MARK: - NSManagedObject
extension Managed where Self: NSManagedObject {
    
    static var entityName: String {
        return entity().name!
    }
    
    static func fetch(in context: NSManagedObjectContext,
                      with sortDescriptors: [NSSortDescriptor] = defaultSortDescriptors,
                      configurationBlock: (NSFetchRequest<Self>) -> Void = { _ in }) -> [Self] {
        let request = NSFetchRequest<Self>(entityName: Self.entityName)
        request.sortDescriptors = sortDescriptors
        configurationBlock(request)
        return (try? context.fetch(request)) ?? []
    }
    
    static func findOrFetch(in context: NSManagedObjectContext, matching predicate: NSPredicate) -> Self? {
        guard let object = materializedObject(in: context, matching: predicate) else {
            return fetch(in: context) { request in
                request.predicate = predicate
                request.returnsObjectsAsFaults = false
                request.fetchLimit = 1
            }.first
        }
        return object
    }
    
    static func materializedObject(in context: NSManagedObjectContext, matching predicate: NSPredicate) -> Self? {
        for object in context.registeredObjects where !object.isFault {
            guard let result = object as? Self, predicate.evaluate(with: result) else { continue }
            return result
        }
        return nil
    }
    
    static func fetchCount(in context: NSManagedObjectContext,
                           expressionDescription: [NSExpressionDescription],
                           configurationBlock: (NSFetchRequest<NSDictionary>) -> Void = { _ in }) -> [NSDictionary] {
        let request = NSFetchRequest<NSDictionary>(entityName: Self.entityName)
        request.resultType = .dictionaryResultType
        request.propertiesToFetch = expressionDescription
        configurationBlock(request)
        return (try? context.fetch(request)) ?? []
    }
}
