//
//  ViewController.swift
//  Todoey
//
//  Created by G. A. KAMPHUIS on 06/05/2018.
//  Copyright © 2018 GAKKIE. All rights reserved.
//

import UIKit

//Because we subclass our TableViewController from the UiTableViewController class, we don't have to manualy set the delegates and datasource or link up any outlets
//like when we manually add a tableView to a viewcontroller! That is all done behind the scenes!

class TodoListViewController: UITableViewController {
    
    var itemArray: [String] = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    //MARK - Tableview Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
        
    }
    
    //MARK - TableView Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath)
        if cell?.accessoryType == .checkmark {
            cell?.accessoryType = .none
        } else {
            cell?.accessoryType = .checkmark
        }
        
    }
    
    
    //MARK - Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //We need a UITextFieldItem within the scope of the addButtonPressed method to be able to set it from within a closure further along, so we can
        //access it outside the closere!
        var textField: UITextField = UITextField()
        
        let alert: UIAlertController = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        
        let action: UIAlertAction = UIAlertAction(title: "Add item", style: UIAlertActionStyle.default) { //closure
            (action) in
            //What will happen once the user clicks the Add item button on our UIAlert
            self.itemArray.append(textField.text!) //Force unwrap. Textfield.text is never nil. When nothing is entered it is "" (empty string). Normally we would prevent adding an empty string!!
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { //closure
            (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField //Assign our local variable to the one we create within thos closure!
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
    }
    
    

    
}

