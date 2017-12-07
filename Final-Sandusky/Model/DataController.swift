//
//  DataController.swift
//  Final-Sandusky
//
//  Created by Taylor Sandusky on 12/6/17.
//  Copyright © 2017 Taylor Sandusky. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    let persistentContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName) //passing the name of the model (Final_Sandusky.xcdatamodeld)
    }
    
    func load() {
        //trailing closure
        persistentContainer.loadPersistentStores { storeDescription, error in //parameters we expect to be coming in for this fuction
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
        }
    }
}
