//
//  CategoryController.swift
//  Todoey
//
//  Created by JINSEOK on 2022/11/11.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class CategoryController: SwipeTableViewController {
    
    // 이미 AppDelegate 실행해서 로컬영역에서는 try!로 간단히 사용
    let realm = try! Realm()
    
    var categorys: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for:.documentDirectory, in: .userDomainMask))
        
        loadCategorys()
        
        tableView.separatorStyle = .none
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let navbar = navigationController?.navigationBar else { fatalError("navi no exist")}
        navbar.backgroundColor = UIColor(.blue)
        navbar.largeTitleTextAttributes = [.foregroundColor: UIColor.blue]
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categorys?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categorys?[indexPath.row] {
            
            cell.textLabel?.text = category.name
            
            cell.backgroundColor = UIColor(hexString: category.colorName)
            cell.textLabel?.textColor = ContrastColorOf(UIColor(hexString: category.colorName)!, returnFlat: true)
        }

     
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destivationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destivationVC.selectCategory = categorys?[indexPath.row]
        }
        
        
    }
    
    func makeAlert() {
        
        var textFiled = UITextField()
        
        let alert = UIAlertController(title: "Add New ToDoey", message: "type message", preferredStyle: .alert)
        
        let add = UIAlertAction(title: "Add", style: .default) { (add) in
            if let message = textFiled.text {
                
                let newCategory = Category()
                newCategory.name = message
                newCategory.colorName = RandomFlatColor().hexValue()
                
                self.saveCategorys(category: newCategory)
            }
            
        }
        let canel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textFiled = alertTextField
        }
        
        alert.addAction(add)
        alert.addAction(canel)
        present(alert, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        makeAlert()
    }
    
    func saveCategorys(category: Category) {
        do {
            try realm.write({
                realm.add(category)
            })
        } catch {
            print("Error save: \(error)")
        }
        tableView.reloadData()
        
    }
    
    func loadCategorys() {
        
        categorys = realm.objects(Category.self)
        tableView.reloadData()
        
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let categorys = self.categorys {
            do {
                try self.realm.write{
                    self.realm.delete(categorys[indexPath.row])
                }
                
            } catch {
                print(error)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

