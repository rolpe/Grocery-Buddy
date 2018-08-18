//
//  TripViewController.swift
//  Grocery Buddy
//
//  Created by Ron Lipkin on 8/16/18.
//  Copyright © 2018 Ron Lipkin. All rights reserved.
//

import UIKit
import RealmSwift

class TripViewController: UITableViewController {
    
    lazy var realm = try! Realm()
    let formatter = DateFormatter()

    var trips: Results<Trip>?

    override func viewDidLoad() {

        print(realm.configuration.fileURL!)
        
        super.viewDidLoad()
        tableView.register(UINib(nibName: "TripCell", bundle: nil), forCellReuseIdentifier: "TripCell")
        formatter.dateStyle = .long
        
        loadTrips()
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TripCell", for: indexPath) as! TripCell
        
        if let trip = trips?[indexPath.row] {
            cell.costLabel.text = trip.cost.cleanValue
            cell.dateLabel.text = formatter.string(from: trip.tripDate)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips?.count ?? 1
    }
    
    func loadTrips() {
        trips = realm.objects(Trip.self)
        tableView.reloadData()
    }
    
    func saveTrip(trip: Trip) {
        do {
            try realm.write {
                realm.add(trip)
            }
        } catch {
            print("Error saving trip: \(error)")
        }
        
        tableView.reloadData()
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let newTrip = Trip()
        saveTrip(trip: newTrip)
        
    }
    
}

extension Double {
    var cleanValue: String{
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "$%.0f", self) : String(format: "$%.2f", self)//
    }
}
