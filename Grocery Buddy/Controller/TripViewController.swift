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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "TripCell", bundle: nil), forCellReuseIdentifier: "TripCell")
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TripCell", for: indexPath) as! TripCell
        
        cell.costLabel.text = "$500"
        cell.dateLabel.text = "August 16, 2018"
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    

}
