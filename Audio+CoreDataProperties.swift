//
//  Audio+CoreDataProperties.swift
//  task_RapidChidori_iOS
//
//  Created by Kaushil Prajapati on 27/01/22.
//
//

import Foundation
import CoreData


extension Audio {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Audio> {
        return NSFetchRequest<Audio>(entityName: "Audio")
    }

    @NSManaged public var id: Double
    @NSManaged public var taskAudio: Data?
    @NSManaged public var note: Note?

}

extension Audio : Identifiable {

}
