//
//  ItemType+CoreDataProperties.swift
//  WishList
//
//  Created by ElectroZone on 2018-02-07.
//  Copyright © 2018 Wassim Mouhajer. All rights reserved.
//
//

import Foundation
import CoreData


extension ItemType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemType> {
        return NSFetchRequest<ItemType>(entityName: "ItemType")
    }

    @NSManaged public var type: String?
    @NSManaged public var toItem: Item?

}
