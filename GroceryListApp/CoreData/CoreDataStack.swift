//
//  CoreDataStack.swift
//  GroceryListApp
//
//  Created by Mahrukh khan on 9/1/19.
//  Copyright © 2019 Mahrukh khan. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
   
    
    var container: NSPersistentContainer {
        
        let container = NSPersistentContainer(name: "GroceryTodo")
        container.loadPersistentStores {(description, error) in
            guard error == nil else {
                print("Error: \(error!)")
                return
            }
        }
        return container
    }
    var managedContext: NSManagedObjectContext {
        return container.viewContext
        
    }
}

