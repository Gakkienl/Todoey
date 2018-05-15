//
//  CatagoryViewController.swift
//  Todoey
//
//  Created by G. A. KAMPHUIS on 14/05/2018.
//  Copyright © 2018 GAKKIE. All rights reserved.
//

import UIKit
import CoreData

class CatagoryViewController: UITableViewController {
    
    //Properties
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categoriesArray: [Category] = [Category]()

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
            
            let newCategory: Category = Category(context: self.context)
            newCategory.name = textField.text!
            
            self.categoriesArray.append(newCategory)
            self.saveCategories()
            
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
        return categoriesArray.count
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category = categoriesArray[indexPath.row]
        cell.textLabel?.text = category.name
        
        return cell
        
    }
    
    
    //MARK: - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoriesArray[indexPath.row] //set a property in the selected (TodoListViewController) VC!
            
            
        }
        
    }
    
    
    
    
    //MARK: - Data Manipulation Methods
    func saveCategories() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
        
        //The reloadDate() method forces the the tableview to call the datasource methods again!
        tableView.reloadData()
        
    }
    
    
    //When called without a request, it defaults to all Categories (Category.fetchRequest())
    //Note:External parameter with and internal paramater request!
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categoriesArray = try context.fetch(request)
        } catch {
            print("Error fetching categories from context: \(error)")
        }
        
        tableView.reloadData()
        
    }

    
    
    
}
