//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var todoItems: Results<Item>?
    
    var selectCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let colorHex = selectCategory?.colorName {
//            searchBar.tintColor =
//            searchBar.barTintColor = UIColor(hexString: colorHex)
//            UITextField. = .blue
            
            searchBar.placeholder = "Search"
            
            searchBar.keyboardType = UIKeyboardType.alphabet
            searchBar.tintColor = UIColor.white
            searchBar.barTintColor = UIColor(hexString: "EB033B")

            UITextField.appearance(whenContainedInInstancesOf: [type(of: searchBar)]).backgroundColor = .yellow
            UITextField.appearance(whenContainedInInstancesOf: [type(of: searchBar)]).tintColor = .blue

            UITextField.appearance().backgroundColor = .white
        
//            UITextField.appearance(whenContainedInInstancesOf: [type(of: searchBar)]).backgroundColor = .yellow
//            UITextField.appearance(whenContainedInInstancesOf: [type(of: searchBar)]).tintColor = .green
//            searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "common_help", attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: colorHex)! ])
            
//            searchBar.backgroundColor = UIColor(hexString: colorHex)
            guard let navBar = navigationController?.navigationBar else {fatalError("Navi does not exist")}
            navBar.standardAppearance.backgroundColor = UIColor(hexString: colorHex)!
            navBar.standardAppearance.titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 20.0),
                                                             .foregroundColor: ContrastColorOf(UIColor(hexString: colorHex)!, returnFlat: true)]
            navBar.scrollEdgeAppearance?.backgroundColor = UIColor(hexString: colorHex)!
            navBar.scrollEdgeAppearance?.titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 20.0),
                                                             .foregroundColor: ContrastColorOf(UIColor(hexString: colorHex)!, returnFlat: true) ]
            navBar.tintColor = ContrastColorOf(UIColor(hexString: colorHex)!, returnFlat: true)

        }
    }
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        makeAlert()
    }
    
    func makeAlert() {
        
        var textFiled = UITextField()
        
        let alert = UIAlertController(title: "Add New ToDoey", message: "type message", preferredStyle: .alert)
        
        let add = UIAlertAction(title: "Add", style: .default) { (add) in
            if let message = textFiled.text {
                
                let newItem = Item()
                newItem.title = message
                newItem.date = Date()
                self.saveItem(itmes: newItem)
                
                self.tableView.reloadData()
            }
        }
        
        
        let canel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textFiled = alertTextField
        }
        
        alert.addAction(add)
        alert.addAction(canel)
        present(alert, animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
            
        } else {
            cell.textLabel?.text = "no item"
        }
        if let color = UIColor(hexString: selectCategory!.colorName)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
            cell.backgroundColor = color
            cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
        }
        
        return cell
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let todoItems = self.todoItems {
            self.deleteItme(itme: todoItems[indexPath.row])
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let item = todoItems?[indexPath.row] {
            updateItem {
                item.done = !item.done
            }
            tableView.reloadData()
        }
        
    }
    
    
    
    
    //     default 값을 이용해서 사용 ⭐️
    func loadItems() {
        // category의 relationship인 itmes를 불러온다
        todoItems = selectCategory?.items.sorted(byKeyPath: "title", ascending: true)
    }
    
    func saveItem(itmes: Item) {
        do {
            try realm.write({
                selectCategory?.items.append(itmes)
            })
        } catch {
            print("Error save: \(error)")
        }
    }
    
    func updateItem(completion: () -> Void) {
        do {
            try realm.write {
                completion()
            }
        } catch {
            print("Error save: \(error)")
        }
    }
    
    func deleteItme(itme: Item) {
        do {
            try realm.write {
                realm.delete(itme)
            }
        } catch {
            print("Error delete: \(error)")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    

}


//
extension TodoListViewController: UISearchBarDelegate {
    
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            tableView.reloadData()
        }
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "date", ascending: true)
        tableView.reloadData()
        
        
    }
}







