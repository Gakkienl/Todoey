//
//  CatagoryViewController.swift
//  Todoey
//
//  Created by G. A. KAMPHUIS on 14/05/2018.
//  Copyright © 2018 GAKKIE. All rights reserved.
//

import UIKit
import RealmSwift

class CatagoryViewController: UITableViewController {
    
    //Properties
    let realm = try! Realm() //Force try, perfecrly safe in this case ...
    
    var categories: Results<Category>? //auto updating container! No need for manual add/delete/update... Made an optional!

    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()


    }

    
    //MARK: - UI actions / Add action
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField: UITextField = UITextField()
        
        let alert: UIAlertController = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        
        let action: UIAlertAction = UIAlertAction(title: "Add category", style: UIAlertActionStyle.default) { //closure
            (action) in
            
            let newCategory: Category = Category()
            newCategory.name = textField.text!
            
            self.save(category: newCategory)
            
        }
        
        
        alert.addTextField { //closure
            (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField //Assign our local variable to the one we create within thos closure!
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)

    }
    
    
    //MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1 //categoriesArray is an optional and thus maybe nill. ?? 1 is the Nil Coalescing Operater, saying when nil return 1
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories yet!" // If catgoriesArray is nil return the text provided!
        
        return cell
        
    }
    
    
    //MARK: - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row] //set a property in the selected (TodoListViewController) VC!
            
            
        }
        
    }
    
    
    
    
    //MARK: - Data Manipulation Methods
    func save(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context: \(error)")
        }
        
        //The reloadDate() method forces the the tableview to call the datasource methods again!
        tableView.reloadData()
        
    }
    
    
    //When called without a request, it defaults to all Categories (Category.fetchRequest())
    //Note:External parameter with and internal paramater request!
    func loadCategories() {
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
        
    }

    
    
    
}
