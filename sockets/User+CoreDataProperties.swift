//
//  User+CoreDataProperties.swift
//  sockets
//
//  Created by Zakhar Rudenko on 18.05.16.
//  Copyright © 2016 Zakhar Rudenko. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension User{

    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var deviceId: String?
    @NSManaged var link_to_image: String?
    @NSManaged var name: String?
    @NSManaged var user: String?

}
