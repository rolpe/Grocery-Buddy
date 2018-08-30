//
//  ItemListViewController.swift
//  Grocery Buddy
//
//  Created by Ron Lipkin on 8/19/18.
//  Copyright © 2018 Ron Lipkin. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ItemTableViewController: SwipeTableViewController {
    
    lazy var realm = try! Realm()
    
    var currentTrip: Trip? {
        didSet {
            loadItems()
        }
    }
    
    let strikeEffect: [NSAttributedStringKey : Any] = [
        NSAttributedStringKey.strikethroughStyle: NSUnderlineStyle.styleSingle.rawValue,
        NSAttributedStringKey.strikethroughColor: UIColor(hexString: "FF6151")!,
        ]
    
    var items: Results<Item>?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - TableView Data Source Methods

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = items?[indexPath.row] {
            cell.textLabel?.text = item.name
            if item.done == true {
                cell.accessoryType = .checkmark
                let strikeThrough = NSAttributedString(string: item.name, attributes: strikeEffect)
                cell.textLabel?.attributedText = strikeThrough
            } else {
                cell.accessoryType = .none
                cell.textLabel?.attributedText = NSAttributedString(string: item.name, attributes: nil)
            }
            cell.tintColor = UIColor(hexString: "FF6151")
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = items?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error changing done property: \(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Grocery Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let trip = self.currentTrip {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.name = textField.text!
                        newItem.price = 0
                        trip.items.append(newItem)
                    }
                } catch {
                    print("Error adding item: \(error)")
                }
                self.tableView.reloadData()
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add New Item"
            alertTextField.autocapitalizationType = .sentences
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: {
            alert.view.superview?.isUserInteractionEnabled = true
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertClose(gesture:))))
        })
    }
    
    //Mark: - Data Manipulation Methods
    
    func loadItems() {
        items = currentTrip?.items.sorted(byKeyPath: "name", ascending: true)
        tableView.reloadData()
    }
    
    override func updateModel(indexPath: IndexPath) {
        if let item = items?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(item)
                }
            } catch {
                print("Error deleting item: \(error)")
            }
        }
    }
}
