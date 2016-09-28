//
//  CoreDataHelper.swift
//  StandardProject
//
//  Created by 赵兵 on 16/8/3.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//


import CoreData


class CoreDataManager: NSObject {
    private static var _defaultManager: CoreDataManager! = nil
    
    static var defaultManager: CoreDataManager! {
        get {
            if _defaultManager == nil {
                _defaultManager = CoreDataManager()
            }
            return _defaultManager
        }
        set {
            _defaultManager = newValue
        }
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1] as NSURL
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "OzneriFamilyModel", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let sqlName = ((UserDefaults.standard.object(forKey: UserDefaultsUserIDKey) ?? "DefaultCoreData") as! String)+".sqlite"
        let url = self.applicationDocumentsDirectory.appendingPathComponent(sqlName)
        var failureReason = "There was an error creating or loading the application's saved data."
        let options = [NSInferMappingModelAutomaticallyOption: true, NSMigratePersistentStoresAutomaticallyOption: true]
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveChanges () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    func create(entityName: String) -> BaseDataObject {
        let entity = managedObjectModel.entitiesByName[entityName]!
        return BaseDataObject(entity: entity, insertInto: managedObjectContext)
    }
    func fetch(entityName: String, ID: NSString, error: NSErrorPointer) -> BaseDataObject? {
        let request : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
        let entity:NSEntityDescription? = NSEntityDescription.entity(forEntityName: entityName, in: managedObjectContext)
        request.entity = entity
        request.predicate = NSPredicate(format: "id = %@", ID)
        request.fetchLimit = 1
        var results = NSArray()
        do {
            results = try managedObjectContext.fetch(request) as NSArray
        } catch {
           return nil
        }
        
        if  results.count != 0 {
            return results[0] as? BaseDataObject
        } else {
            return nil
        }
    }
    func fetchAll(entityName: String, error: NSErrorPointer) -> [BaseDataObject] {
        let request : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
        let entity:NSEntityDescription? = NSEntityDescription.entity(forEntityName: entityName, in: managedObjectContext)
        request.entity = entity
        var results = NSArray()
        do {
            results = try managedObjectContext.fetch(request) as NSArray
        } catch {
            print("获取本地数据失败")
        }
        return (results as? [BaseDataObject])!
        
    }
    func autoGenerate(entityName: String, ID: NSString) -> BaseDataObject {
        var object = fetch(entityName: entityName, ID: ID, error: nil)
        if object == nil {
            object = create(entityName: entityName)
            object!.setValue(ID, forKey: "id")
        }
        return object!
    }
    func deleteObjectsWithIDs(entityName: String,IDArray:[NSString]) {
        let request : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
        let entity:NSEntityDescription? = NSEntityDescription.entity(forEntityName: entityName, in: managedObjectContext)
        request.predicate = NSPredicate(value: true)
        request.entity = entity
        var results = NSArray()
        do {
            results = try managedObjectContext.fetch(request) as NSArray
        } catch {
            print("获取本地数据失败")
        }
        for r in results {
            if IDArray.contains((r as! NSManagedObject).value(forKey: "id")  as! NSString)
            {
                managedObjectContext.delete(r as! NSManagedObject)
            }
        }
        saveChanges()
    }
    func deleteAllObjectsWithEntityName(entityName: String) {
        let request : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
        let entity:NSEntityDescription? = NSEntityDescription.entity(forEntityName: entityName, in: managedObjectContext)
        request.predicate = NSPredicate(value: true)
        request.entity = entity
        var results = NSArray()
        do {
            results = try managedObjectContext.fetch(request) as NSArray
        } catch {
            print("获取本地数据失败")
        }
        for r in results {
            managedObjectContext.delete(r as! NSManagedObject)
        }
        saveChanges()
    }
    
}
