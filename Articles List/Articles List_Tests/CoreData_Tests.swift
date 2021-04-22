//
//  CoreData_Tests.swift
//  Articles List_Tests
//
//  Created by Agustin Errecalde on 22/04/2021.
//

import XCTest
import CoreData

class CoreData_Tests: XCTestCase {

    var testPersistentContainer: NSPersistentContainer?
    
    override func setUp() {
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType

        let container = NSPersistentContainer(name: "ArticleModelCD")
        container.persistentStoreDescriptions = [persistentStoreDescription]
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError(error.localizedDescription)
            }
        }

        self.testPersistentContainer = container
    }
    
    func testHasContainerNotNil() {
        XCTAssertNotNil(self.testPersistentContainer)
    }
}
