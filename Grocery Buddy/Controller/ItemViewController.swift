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
        
        //Set up title and cost label
        if let trip = currentTrip {
            costLabel.text = trip.cost.cleanValue
            let df = DateFormatter()
            df.dateStyle = .long
            self.title = df.string(from: trip.tripDate)
        }
    }
    
    //MARK: - Embedded TableView Methods
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
    
    //MARK: - Done Button Functionality
    
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
            alertTextField.keyboardType = UIKeyboardType.decimalPad
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: {
            alert.view.superview?.isUserInteractionEnabled = true
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertClose(gesture:))))
        })
    }
    
    @objc func alertClose(gesture: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
