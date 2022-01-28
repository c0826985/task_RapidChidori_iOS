//
//  Image+CoreDataProperties.swift
//  task_RapidChidori_iOS
//
//  Created by Rohit Sharma on 28/01/22.
//
//

import Foundation
import CoreData


extension Image {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Image> {
        return NSFetchRequest<Image>(entityName: "Image")
    }

    @NSManaged public var id: Double
    @NSManaged public var noteImage: Data?
    @NSManaged public var note: Note?

}

extension Image : Identifiable {

}
