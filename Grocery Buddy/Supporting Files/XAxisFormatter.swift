//
//  XAxisFormatter.swift
//  Grocery Buddy
//
//  Created by Ron Lipkin on 8/25/18.
//  Copyright © 2018 Ron Lipkin. All rights reserved.
//

import Foundation
import Charts

public class XAxisFormatter: IAxisValueFormatter {
        
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
}
