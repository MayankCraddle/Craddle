//
//  Cart+CoreDataProperties.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 19/08/22.
//
//

import Foundation
import CoreData


extension Cart {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Cart> {
        return NSFetchRequest<Cart>(entityName: "Cart")
    }

    @NSManaged public var name: String?
    @NSManaged public var soldBy: String?
    @NSManaged public var price: Int64
    @NSManaged public var id: Int64
    @NSManaged public var currency: String?
    @NSManaged public var stock: Int64
    @NSManaged public var itemId: String?

}

extension Cart : Identifiable {

}
