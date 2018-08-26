//
//  TripViewController.swift
//  Grocery Buddy
//
//  Created by Ron Lipkin on 8/16/18.
//  Copyright © 2018 Ron Lipkin. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TripTableViewController: SwipeTableViewController {
    
    lazy var realm = try! Realm()
    let formatter = DateFormatter()
    
    var alertDateTextField = UITextField()
    
    var trips: Results<Trip>?

    override func viewDidLoad() {

        print(realm.configuration.fileURL!)
        super.viewDidLoad()
        tableView.register(UINib(nibName: "TripCell", bundle: nil), forCellReuseIdentifier: "Cell")
        formatter.dateStyle = .long
        
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
        self.view.addGestureRecognizer(longGesture)
        
        loadTrips()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! TripCell
        
        if let trip = trips?[indexPath.row] {
            cell.costLabel.text = trip.cost.cleanValue
            cell.dateLabel.text = formatter.string(from: trip.tripDate)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToTrip", sender: self)
    }
    
    @objc func longPress(_ guesture: UILongPressGestureRecognizer) {
        if guesture.state == UIGestureRecognizerState.began {
            let point = guesture.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: point) {
                changeDate(indexPath: indexPath)
            }
        }
    }
    
    func changeDate(indexPath: IndexPath) {
        let datePicker = UIDatePicker()
        
        let alert = UIAlertController(title: "Change Trip Date", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Update Date", style: .default) { (action) in
            if let trip = self.trips?[indexPath.row] {
                do {
                    try self.realm.write {
                        trip.tripDate = datePicker.date
                    }
                } catch {
                    print("Error changing date: \(error)")
                }
                self.tableView.reloadData()
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Select Trip Date"
            alertTextField.inputView = datePicker
            alertTextField.text = self.formatter.string(from: datePicker.date)
            self.alertDateTextField = alertTextField
        }
        
        datePicker.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
        datePicker.datePickerMode = .date
        
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: {
            alert.view.superview?.isUserInteractionEnabled = true
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertClose(gesture:))))
        })
    }
    
    @objc func datePickerChanged(picker:UIDatePicker) {
        alertDateTextField.text = formatter.string(from: picker.date)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ItemViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.currentTrip = trips?[indexPath.row]
        }
    }
    
    func loadTrips() {
        trips = realm.objects(Trip.self)
        trips = trips?.sorted(byKeyPath: "tripDate", ascending: true)
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
        tableView.scrollToRow(at: IndexPath(row: (trips?.count)! - 1, section: 0), at: .bottom, animated: true)
    }
    
    override func updateModel(indexPath: IndexPath) {
        if let trip = trips?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(trip.items)
                    realm.delete(trip)
                }
            } catch {
                print("Error deleting trip: \(error)")
            }
        }
    }
}

extension Double {
    var cleanValue: String{
        return String(format: "$%.2f", self)
    }
}
