//
//  TripCell.swift
//  Grocery Buddy
//
//  Created by Ron Lipkin on 8/16/18.
//  Copyright © 2018 Ron Lipkin. All rights reserved.
//

import UIKit
import SwipeCellKit

class TripCell: SwipeTableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
