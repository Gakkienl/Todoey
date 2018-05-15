//
//  ViewController.swift
//  Todoey
//
//  Created by G. A. KAMPHUIS on 06/05/2018.
//  Copyright © 2018 GAKKIE. All rights reserved.
//

import UIKit
import CoreData

//Because we subclass our TableViewController from the UiTableViewController class, we don't have to manualy set the delegates and datasource or link up any outlets
//like when we manually add a tableView to a viewcontroller! That is all done behind the scenes!

class TodoListViewController: UITableViewController {
    
    //We will need a reference to the object of our AppDelegate class to be able to use the context of our core Data
    //UIApplication.sahred is the singelton Application instance!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var itemArray: [Item] = [Item]()
    var selectedCategory: Category? {// optional category. So may and can be nil!
        didSet { // will happen as soon as it gets set!
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadItems()
        
    }

    //MARK: - Tableview Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        //Ternary operator >
        //value = condition ? valueIfTrue : valueIffalse
        //Reads: cell.accssoryType will be .checkmark when item.done is true, else .none!
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
        
    }
    
    //MARK: - TableView Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //itemArray[indexPath.row] is a NSManagedObject (a row)
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done // ! means "not", ie the opposite. It's a toggle!

        //make sure the changes are reflected on screen and persisted
        saveItems()

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
            
            let newItem: Item = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false // default to false!
            newItem.parentCategory = self.selectedCategory
            
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
        
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
        
        //The reloadDate() method forces the the tableview to call the datasource methods again!
        tableView.reloadData()

    }
    
    
    //When called without a request, it defaults to all Items (Item.fetchRequest())
    //Note:External parameter with and internal paramater request! The second param (predicate) is an optional and had a default value of nil!
    //Therefor loadItems() can be called without supplying any param!
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        //Combine Category and Search predicates
        if let additionalPredicate = predicate {
           request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else { //No search, load all items for category
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context: \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    
}


//MARK: - Search Bar functionality
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!) //[cd] means NOT Case sensitive and not Diacritic sensitive
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)] //expects an array of sortdescriptors! In this case an array with one member
        
        loadItems(with: request, predicate: predicate)
        
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


