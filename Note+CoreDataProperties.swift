//
//  Note+CoreDataProperties.swift
//  task_RapidChidori_iOS
//
//  Created by Shubham Behal on 28/01/22.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var audio: Data?
    @NSManaged public var category: String?
    @NSManaged public var date: Date?
    @NSManaged public var detail: String?
    @NSManaged public var id: Int32
    @NSManaged public var image: Data?
    @NSManaged public var status: Bool
    @NSManaged public var title: String?
    @NSManaged public var dueDate: String?
    @NSManaged public var images: NSSet?

}

// MARK: Generated accessors for images
extension Note {

    @objc(addImagesObject:)
    @NSManaged public func addToImages(_ value: Image)

    @objc(removeImagesObject:)
    @NSManaged public func removeFromImages(_ value: Image)

    @objc(addImages:)
    @NSManaged public func addToImages(_ values: NSSet)

    @objc(removeImages:)
    @NSManaged public func removeFromImages(_ values: NSSet)

}

extension Note : Identifiable {

}
