//
//  CategoryViewController.swift
//  ToDoey
//
//  Created by Ofir Elias on 09/07/2019.
//  Copyright © 2019 Ofir Elias. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categoryArray: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        tableView.separatorStyle = .none
        tableView.rowHeight = 80.0
    }
    
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categoryArray?[indexPath.row] {
            cell.textLabel?.text = category.name
            
            cell.backgroundColor = UIColor.init(hexString: category.color)
            
            guard let categoryColor = UIColor(hexString: category.color) else {fatalError()}
            
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray?.count ?? 1
    }
    
    
    //MARK: - Data Manipulation Methods
    
    func save(category: Category){
        do{
            try realm.write {
                realm.add(category)
                }
        }catch{
            print("Error saving data \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories() {
        
       categoryArray = realm.objects(Category.self)

        self.tableView.reloadData()
    }
    
    
    //MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let category = self.categoryArray?[indexPath.row] {
            do{
                try self.realm.write {
                    self.realm.delete(category)
                }
            }catch {
                print("Error Deleting The Category \(error)")
            }
        }
        
    }
    
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        
        let alert = UIAlertController(title: "Add A New List Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (done) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
            newCategory.color = UIColor.randomFlat.hexValue()
            self.save(category: newCategory)
            
        }
        
        alert.addTextField { (alertTextFiled) in
            alertTextFiled.placeholder = "Create A New Category"
            textField = alertTextFiled
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - TableView Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
}
