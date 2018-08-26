//
//  ChartViewController.swift
//  Grocery Buddy
//
//  Created by Ron Lipkin on 8/21/18.
//  Copyright © 2018 Ron Lipkin. All rights reserved.
//

import UIKit
import ChartsRealm
import Charts
import RealmSwift
import ChameleonFramework

class ChartViewController: UIViewController {
    
    @IBOutlet weak var lineChart: LineChartView!
    @IBOutlet weak var averageLabel: UILabel!
    
    var calendar = Calendar.current
    
    lazy var realm = try! Realm()
    
    var allTrips: Results<Trip>?
    
    let xFormatter = XAxisFormatter()
    let yFormatter = YAxisFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateChartData()
        setChartLayout()
        updateAverage()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateChartData()
        updateAverage()
    }

    func updateChartData() {
        allTrips = realm.objects(Trip.self)
        
        guard let trips = allTrips else {
            fatalError()
        }
        
        var dataEntries: [ChartDataEntry]  = []
        for i in 0..<trips.count {
            let timeIntervalForDate: TimeInterval =  calendar.startOfDay(for: trips[i].tripDate).timeIntervalSince1970
            let dataEntry = ChartDataEntry(x: Double(timeIntervalForDate), y: trips[i].cost)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = LineChartDataSet(values: dataEntries, label: "Trip Cost")
        chartDataSet.lineWidth = 3
        chartDataSet.colors = [UIColor(hexString: "02C39A")] as! [NSUIColor]
        chartDataSet.circleColors = [UIColor(hexString: "FF6151")] as! [NSUIColor]
        
        
        let chartData = LineChartData(dataSet: chartDataSet)
        chartData.setDrawValues(false)
        lineChart.data = chartData
        
        let xAxis = lineChart.xAxis
        xAxis.setLabelCount(trips.count < 6 ? trips.count : 6, force: true)
        xAxis.valueFormatter = xFormatter
        xAxis.labelPosition = .bottom
        xAxis.drawGridLinesEnabled = false
        
        let yAxis = lineChart.leftAxis
        yAxis.valueFormatter = yFormatter
        
    }
    
    func setChartLayout() {
        lineChart.chartDescription?.enabled = false
        lineChart.rightAxis.enabled = false
        lineChart.leftAxis.drawGridLinesEnabled = false
        lineChart.leftAxis.drawLabelsEnabled = true
        lineChart.extraRightOffset = 20
    }
    
    func updateAverage() {
        if let average: Double = allTrips?.average(ofProperty: "costInCents") {
            averageLabel.text = "Average: $" + String(format: "%.2f", average/100)
        } else {
            averageLabel.text = "No Data Yet"
        }
    }

}
