//
//  ItemListViewController.swift
//  Grocery Buddy
//
//  Created by Ron Lipkin on 8/19/18.
//  Copyright © 2018 Ron Lipkin. All rights reserved.
//

import UIKit
import RealmSwift


class ItemViewController: UIViewController {
    
    lazy var realm = try! Realm()
    @IBOutlet weak var costLabel: UILabel!
    var currentTrip: Trip?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let trip = currentTrip {
            costLabel.text = trip.cost.cleanValue
            let df = DateFormatter()
            df.dateStyle = .long
            self.title = df.string(from: trip.tripDate)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ItemTableViewController
        if let trip = currentTrip {
            destinationVC.currentTrip = trip
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        if let childVC = childViewControllers.last as? ItemTableViewController {
            childVC.addButtonPressed(sender)
        }

    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Enter Total Cost", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Cost", style: .default) { (action) in
            if let trip = self.currentTrip {
                do {
                    try self.realm.write {
                        trip.cost = Double(textField.text ?? "") ?? 0
                    }
                } catch {
                    print("Error saving cost: \(error)")
                }
                self.costLabel.text = trip.cost.cleanValue
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter total cost"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
}
