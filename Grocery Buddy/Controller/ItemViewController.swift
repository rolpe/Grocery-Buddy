//
//  ItemListViewController.swift
//  Grocery Buddy
//
//  Created by Ron Lipkin on 8/19/18.
//  Copyright © 2018 Ron Lipkin. All rights reserved.
//

import UIKit

class ItemViewController: UIViewController {
    
    var currentTrip: Trip?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
}
