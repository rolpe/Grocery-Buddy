//
//  Trip.swift
//  Grocery Buddy
//
//  Created by Ron Lipkin on 8/13/18.
//  Copyright © 2018 Ron Lipkin. All rights reserved.
//

import Foundation
import RealmSwift

class Trip {
    
    @objc dynamic var tripDate = Date()
    @objc private dynamic var costInCents: Double = 0
    
    var cost: Double {
        get {
            return costInCents/100.0
        }
        set {
            costInCents = newValue * 100
        }
    }
}
