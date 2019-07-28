//
//  ViewController.swift
//  ToDoey
//
//  Created by Ofir Elias on 08/07/2019.
//  Copyright © 2019 Ofir Elias. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController {
        
    @IBOutlet weak var searchBar: UISearchBar!
    
    let realm = try! Realm()
    var items: Results<Item>?
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        title = selectedCategory?.name

        guard let colourHax = selectedCategory?.color else {fatalError()}
        
        updateNavBar(withHexCode: colourHax)
    }
    
    override func viewWillDisappear(_ animated: Bool) {        
        updateNavBar(withHexCode: "1D9BF6")
    }

    //MARK: - Nav Bar Setup Methods
    func updateNavBar(withHexCode colourHaxCode: String){
        
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller dose not exist")}
        
        guard let navBarColour = UIColor(hexString: colourHaxCode) else {fatalError()}

        navBar.barTintColor = navBarColour
        
        navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
        
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(navBarColour, returnFlat: true)]
        
        navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(navBarColour, returnFlat: true)]
        
        searchBar.barTintColor = navBarColour

    }
    
    //MARK: - TableView Datasource Methods

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        
        if let item = items?[indexPath.row]{
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.isChecked ? .checkmark : .none
            
            if let categoryColour =  UIColor(hexString: selectedCategory!.color)?.flatten() {
                cell.backgroundColor = categoryColour.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(items!.count))
                cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
            }
            
            print(CGFloat(indexPath.row) / CGFloat(items!.count))
        }else{
            cell.textLabel?.text = "No Items Added"
        }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    
    //MARK: - Modle Manupulation Methods
    
    func loadItems(){
        
        items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
    
    //MARK: - Delete data from swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = self.items?[indexPath.row] {
            do{
                try self.realm.write {
                    self.realm.delete(item)
                }
            }catch {
                print("Error Deleting The Item \(error)")
            }
        }
    }
    
    
    //MARK: - Add New Item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New ToDoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (done) in
            
            if let currentCategory = self.selectedCategory {
                
                do{
                    try self.realm.write {
                        let newItem = Item()
                        if let text = textField.text {
                            newItem.title = text
                        }
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch{
                    print("Error Saving Item, \(error)")
                }
            }
            
            
            self.tableView.reloadData()
        }
        
        alert.addTextField(configurationHandler: { (alertTextField) in
            
            textField.placeholder = "Create New Item"
            
            textField = alertTextField
        })
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = items?[indexPath.row] {
            do{
                try realm.write {
                    item.isChecked = !item.isChecked
                }
            }catch{
                print("Error Saving Checked item \(error)")
            }
        }
        tableView.reloadData()

        tableView.deselectRow(at: indexPath, animated: true)
    }
}

    //MARK: - Search Bar Methods

extension ToDoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        items = items?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

