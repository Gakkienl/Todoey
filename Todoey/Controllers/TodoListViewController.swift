//
//  ViewController.swift
//  Todoey
//
//  Created by G. A. KAMPHUIS on 06/05/2018.
//  Copyright © 2018 GAKKIE. All rights reserved.
//

import UIKit
import RealmSwift

//Because we subclass our TableViewController from the UiTableViewController class, we don't have to manualy set the delegates and datasource or link up any outlets
//like when we manually add a tableView to a viewcontroller! That is all done behind the scenes!

class TodoListViewController: UITableViewController {
    
    let realm = try! Realm()
    var todoItems: Results<Item>?
    
    var selectedCategory: Category? {// optional category. So may and can be nil!
        didSet { // will happen as soon as it gets set!
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        //loadItems()
        
    }

    //MARK: - Tableview Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items added!"
            
        }
        
        return cell
        
    }
    
    //MARK: - TableView Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do{
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error updating item \(item); \(error)")
            }
            
        }

        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    //MARK: - Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //We need a UITextFieldItem within the scope of the addButtonPressed method to be able to set it from within a closure further along, so we can
        //access it outside the closere!
        var textField: UITextField = UITextField()
        
        let alert: UIAlertController = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        
        let action: UIAlertAction = UIAlertAction(title: "Add item", style: UIAlertActionStyle.default) { //closure
            (action) in

            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem: Item = Item()
                        newItem.title = textField.text!
                        currentCategory.items.append(newItem) //append to the List for the currenCategory!
                    }
                } catch {
                    print("Error saving Item to LIst for \(currentCategory); \(error)")
                }

            }
            
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
    
    
    //MARK: - Model manipulation Methods
    func loadItems() {

        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()

    }
    
    
}


//MARK: - Search Bar functionality (Extension)
extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!) //[cd] means NOT Case sensitive and not Diacritic sensitive
        todoItems = todoItems?.filter(predicate).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
        
    }


    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //when text was entered and then is empty, the search has stopped, so load all items back again
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async { //get the main queue and the run my command
               searchBar.resignFirstResponder() //remove focus from searchbar and close keyboard
            }

        } else { //Search as we type!
            searchBarSearchButtonClicked(searchBar)
        }

    }


}


