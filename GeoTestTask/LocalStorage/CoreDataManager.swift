//
//  CoreDataManager.swift
//  GeoTestTask
//
//  Created by Sergiy Sobol on 24.11.2021.
//

import CoreData

enum CoreDataError: Error {
    case directoryError
    case loadError
}

final class CoreDataManager {
    private init() {}
    
    static let shared = CoreDataManager()
    
    lazy var applicationDocumentsDirectory: URL? = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls.last
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel? = {
        guard let modelURL = Bundle.main.url(forResource: "GeoTestTask", withExtension: "momd")
        else {
            return nil
        }
        return NSManagedObjectModel(contentsOf: modelURL)
    }()
    
    func getPersistentStoreCoordinator() -> Result<NSPersistentStoreCoordinator?, CoreDataError> {
        guard let directory = self.applicationDocumentsDirectory,
              let managedObjectModel = self.managedObjectModel else {
                  return .failure(.directoryError)
              }
        
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        let url = directory.appendingPathComponent("RxCoreData.sqlite")
        
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            return .failure(.loadError)
        }
        
        return .success(coordinator)
    }
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        switch self.getPersistentStoreCoordinator() {
        case .success(let coordinator):
            var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            managedObjectContext.persistentStoreCoordinator = coordinator
            return managedObjectContext
        case .failure(let error):
            return nil
        }
    }()
}
