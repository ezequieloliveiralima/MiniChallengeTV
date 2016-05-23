//
//  CDProduct+CoreDataProperties.swift
//  MiniChallengeTV
//
//  Created by Ezequiel de Oliveira Lima on 23/05/16.
//  Copyright © 2016 BEPiD. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension CDProduct {

    @NSManaged var id: NSNumber?
    @NSManaged var name: String?
    @NSManaged var thumbnail: String?

}
