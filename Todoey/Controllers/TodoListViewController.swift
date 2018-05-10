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
    
    //let defaults: UserDefaults = UserDefaults.standard
    
    var itemArray: [Item] = [Item]()
    //Create a filepath of the sandbox documents folder
    //Note: FileManager.default > Shared Instance > Singleton!
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist") //first item from this array!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath!)
        
        loadItems()

        
    }

    //MARK - Tableview Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.titel
        
        //Ternary operator >
        //value = condition ? valueIfTrue : valueIffalse
        //Reads: cell.accssoryType will be .checkmark when item.done is true, else .none!
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
        
    }
    
    //MARK - TableView Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done // ! means "not", ie the opposite. It's a toggle!
        
        //make sure the changes are reflected on screen and persisted in our plist
        saveItems()

        tableView.deselectRow(at: indexPath, animated: true)
        
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
            let newItem: Item = Item()
            newItem.titel = textField.text!
            
            self.itemArray.append(newItem)
            self.saveItems()
            
        }
        
        alert.addTextField { //closure
            (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField //Assign our local variable to the one we create within thos closure!
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
    }
    
    
    //MARK: - Model manipulation Methods!
    func saveItems() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array \(error)")
        }
        
        //The reloadDate() method forces the the tableview to call the datasource methods again!
        tableView.reloadData()

    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) { // try? result will be an optional! try? means do it if it is not an optional. Can be used instead of a do catch block, but will not catch the error
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data) //writing .sef after a datatype means to look at the Type rather than the instance
            } catch {
                print("Error decoding Items: \(error)")
            }
        }
        
    
    }
    
    
    
}

