//
//  YAxisFormatter.swift
//  Grocery Buddy
//
//  Created by Ron Lipkin on 8/25/18.
//  Copyright © 2018 Ron Lipkin. All rights reserved.
//

import Foundation

import Foundation
import Charts

public class YAxisFormatter: IAxisValueFormatter {
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return String(format: "$%.00f", value)
    }
}
