//
//  Item.swift
//  Grocery Buddy
//
//  Created by Ron Lipkin on 8/13/18.
//  Copyright © 2018 Ron Lipkin. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var done: Bool = false
    @objc private dynamic var priceInCents: Double = 0
   
    
    var trip = LinkingObjects(fromType: Trip.self, property: "items")
    
    var price: Double {
        get {
            return priceInCents/100.0
        }
        set {
            priceInCents = newValue * 100
        }
    }
}
