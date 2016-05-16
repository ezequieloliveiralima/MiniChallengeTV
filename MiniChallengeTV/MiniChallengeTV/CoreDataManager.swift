import UIKit
import CoreData

class CoreDataManager {
    static var instance: CoreDataManager = CoreDataManager()
    private init() {}
    
    lazy var managedContext: NSManagedObjectContext = {
        var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var coreData = appDelegate.managedObjectContext
        return coreData
        }()
    
    func create(entity: String) -> NSManagedObject {
        return NSEntityDescription.insertNewObjectForEntityForName(entity, inManagedObjectContext: self.managedContext)
    }

    func all(entity: String) -> [NSManagedObject] {
        do {
            let results = try self.managedContext.executeFetchRequest(NSFetchRequest(entityName: entity))
            if let array = results as? [ NSManagedObject ] {
                return array
            }
        } catch _ {
            
        }
        
        return Array<NSManagedObject>()
    }

    func update(object: NSManagedObject) {
        self.managedContext.refreshObject(object, mergeChanges: true)
        do {
            try self.managedContext.save()
        } catch _ {
            
        }
    }

    func delete(object: NSManagedObject) {
        self.managedContext.deleteObject(object)
        do {
            try self.managedContext.save()
        } catch _ {
            
        }
    }

    func query(entity: String, predicate: NSPredicate) -> [ NSManagedObject ] {
        do {
            let results = try self.managedContext.executeFetchRequest(NSFetchRequest(entityName: entity))
            if let arrr = results as? [ NSManagedObject ] {
                let set = NSOrderedSet(array: arrr)
                let array = NSArray(array: set.array)
                return array.filteredArrayUsingPredicate(predicate) as! Array<NSManagedObject>
            }
        } catch _ {
            
        }
        
        return Array<NSManagedObject>()
    }
    
    func save() {
        do {
            try managedContext.save()
        } catch _ {}
    }
}