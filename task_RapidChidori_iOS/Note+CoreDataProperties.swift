//
//  Note+CoreDataProperties.swift
//  task_RapidChidori_iOS
//
//  Created by Rohit Sharma on 23/01/22.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var category: String?
    @NSManaged public var id: Int32
    @NSManaged public var title: String?
    @NSManaged public var detail: String?
    @NSManaged public var date: Date?

}

extension Note : Identifiable {

}
