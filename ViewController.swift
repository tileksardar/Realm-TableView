//
//  ViewController.swift
//  RealmDemo
//
//  Created by Tilek on 7/3/22.
//

import UIKit
import RealmSwift


class TasksList: Object {
    @objc dynamic var task = ""
    @objc dynamic var completed = false
}

class ViewController:  UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    let realm = try! Realm()
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var items: Results<TasksList>!
   var cellId = "Cell"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        tableView.delegate = self
        tableView.dataSource = self

        
        view.backgroundColor = .white
        
      
        navigationController?.navigationBar.tintColor = .white

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Добавить", style: .plain, target: self, action: #selector(addItem))
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        items = realm.objects(TasksList.self)
        
        
        
        
    }
    
    
    
    //MARK: TableView DataSource
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if items.count != 0{
        return items.count
    }
        return 0
    }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
    let item = items[indexPath.row]
    cell.textLabel?.text = item.task
    return cell
    }
    //MARK: TableView Delegates
        
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
    
    let editingRow = items[indexPath.row]
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (_,_ ) in
            try! self.realm.write{
                self.realm.delete(editingRow)
                tableView.reloadData()

            }
        }
        return [deleteAction]
    }
    
    @objc func addItem(){
        
        
        
        addAlertForNewItem()
    }
    func addAlertForNewItem(){
        
        let alert = UIAlertController(title: "New Task", message: "Fill in fields", preferredStyle: .alert)
        
        var alertTextField: UITextField!
        alert.addTextField { textField in
            alertTextField = textField
            textField.placeholder = "New Tast"
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
            guard let text = alertTextField.text, !text.isEmpty else {return}

           let task = TasksList()
            task.task = text
            
            try! self.realm.write{
                self.realm.add(task)
            }
            self.tableView.insertRows(at: [IndexPath.init(row: self.items.count-1, section: 0)], with: .automatic)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
}
