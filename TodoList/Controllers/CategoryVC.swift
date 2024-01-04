//
//  CategoryVC.swift
//  TodoList
//
//  Created by PavunRaj on 03/01/24.
//

import UIKit
import CoreData
import SwipeCellKit

class CategoryVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categoryArr =  [Category]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CategoryCell", bundle: nil), forCellReuseIdentifier: "CategoryCell")
        tableView.delegate =  self
        tableView.dataSource =  self
        navigationItem.title = "Category"
        loadCategory()
    }
    

    // MARK: - NavigationBar button action
    
    
    @IBAction func addBtnTap(_ sender: UIBarButtonItem) {
        var textFiled = UITextField()
        let alertView = UIAlertController(title: "Add New Item", message: "Would like to add", preferredStyle:.alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
           // let item = Item()
            let item = Category(context: self.context)
            item.name = textFiled.text ?? "Dd"
          //  print("Success.",)
            self.categoryArr.append(item)
            self.saveCategory()
        
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        alertView.addTextField { filed in
            textFiled =  filed
            textFiled.placeholder = "Enter the text"
        }
        alertView.addAction(action)
        
        present(alertView, animated: true)
    }
    
    
    // MARK: - Data Model manupulation
    func saveCategory() {
        do {
           try? context.save()
            print("Saved")
        } catch {
            print(error)
        }
        
        /*
         // Using custom info.plist save the information
        let encode = PropertyListEncoder()
        do {
           let data =  try encode.encode(itemArr)
           try data.write(to: fileManager!)
        } catch {
            print (error.localizedDescription)
        }
         
        */
        
        
    }
    
    func loadCategory(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        let fetchReq : NSFetchRequest<Category> = Category.fetchRequest()

        /*
        do {
            let decode =  PropertyListDecoder()
            let path = try Data(contentsOf: fileManager!)
           itemArr =  try decode.decode([Item].self, from: path)
        } catch {
            
        }
         */
        
        do {
            categoryArr =  try context.fetch(fetchReq)
        } catch {
            print(error)
        }
        tableView.reloadData()
    }
}


extension CategoryVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        vc.selectedCategory =  categoryArr[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
   
}

extension CategoryVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        cell.delegate = self
        
       
        cell.categoryName.text = categoryArr[indexPath.row].name
        return cell
    }
    
    
}


extension CategoryVC: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            print("Delete")
            let commit = self.categoryArr[indexPath.row]
            self.context.delete(commit)
            self.categoryArr.remove(at: indexPath.row)
           // tableView.deleteRows(at:[indexPath], with: .fade)

            self.saveCategory()
        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")

        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
}

