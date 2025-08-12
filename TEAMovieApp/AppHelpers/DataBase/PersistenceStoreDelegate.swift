//
//  PersistenceStoreDelegate.swift
//  TEAMovieApp
//
//  Created by Mohamed abdelhamed on 11/08/2025.
//

import CoreData

protocol PersistenceStoreDelegate: AnyObject {
    func persistenceStore(didUpdateEntity update: Bool)
}

class PersistenceStore<Entity: NSManagedObject>: NSObject, NSFetchedResultsControllerDelegate {
    
    // MARK: - Properties
    private let persistentContainer: NSPersistentContainer
    private var fetchedResultsController: NSFetchedResultsController<Entity>!
    private var changeTypes: [NSFetchedResultsChangeType] = []
    
    weak var delegate: PersistenceStoreDelegate?
    
    var backgroundContext: NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }
    
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    var managedObjectContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Init
    init(_ persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
        super.init()
    }
    
    // MARK: - Configure Fetched Results Controller
    func configureResultsController(batchSize: Int,
                                    limit: Int,
                                    sortDescriptors: [NSSortDescriptor] = [],
                                    predicate: NSPredicate? = nil,
                                    notifyChangesOn changeTypes: [NSFetchedResultsChangeType] = [.insert, .delete, .move, .update]) {
        
        guard let entityName = Entity.entity().name else { fatalError("❌ Entity name not found") }
        
        let request = NSFetchRequest<Entity>(entityName: entityName)
        request.fetchBatchSize = batchSize
        request.fetchLimit = limit
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        request.returnsObjectsAsFaults = false
        
        self.changeTypes = changeTypes
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                              managedObjectContext: managedObjectContext,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("❌ Failed to perform fetch: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Count Entities
    func totalCount() -> Int {
        let request = NSFetchRequest<NSNumber>(entityName: String(describing: Entity.self))
        request.resultType = .countResultType
        
        do {
            let count = try managedObjectContext.count(for: request)
            return count
        } catch {
            print("❌ Failed to fetch count: \(error.localizedDescription)")
            return 0
        }
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                           didChange anObject: Any,
                           at indexPath: IndexPath?,
                           for type: NSFetchedResultsChangeType,
                           newIndexPath: IndexPath?) {
        guard changeTypes.contains(type) else { return }
        
        if anObject as? Entity != nil {
            delegate?.persistenceStore(didUpdateEntity: true)
        }
    }
}
