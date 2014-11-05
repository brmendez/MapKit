//
//  Reminder.swift
//  MapKit
//
//  Created by Brian Mendez on 11/5/14.
//  Copyright (c) 2014 Brian Mendez. All rights reserved.
//

import Foundation
import CoreData

class Reminder: NSManagedObject {

    @NSManaged var coordinate: String
    @NSManaged var date: NSDate
    @NSManaged var name: String
    @NSManaged var radius: NSNumber

}
