//
//  Item+CoreDataClass.swift
//  WishList
//
//  Created by ElectroZone on 2018-02-07.
//  Copyright © 2018 Wassim Mouhajer. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Item)
public class Item: NSManagedObject {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        
        self.created = NSDate()
    }
}
