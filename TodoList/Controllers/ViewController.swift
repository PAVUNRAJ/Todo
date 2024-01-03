//
//  ViewController.swift
//  TodoList
//
//  Created by PavunRaj on 02/01/24.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    var itemArr = [Item]()
    var fileManager =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist", isDirectory: true)
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedCategory : Category? {
        didSet {
            loadItem()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //print(fileManager)
        print(context)
        
        navigationItem.title =  "ToDo"
        tableView.register(UINib(nibName: "Cell", bundle: nil), forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
      //  tableView.reloadData()
       /*
        let item =  Item()
        item.title =  "Welcome"
        itemArr.append(item)
        
        let item1 =  Item()
        item1.title =  "Buddy"
        itemArr.append(item1)
        
        let item2 =  Item()
        item2.title =  "Sunny"
        itemArr.append(item2)
        */
        let req : NSFetchRequest<Item> = Item.fetchRequest()
        loadItem(with: req)
    }


    @IBAction func addItemBtnTap(_ sender: UIBarButtonItem) {
        var textFiled = UITextField()
        let alertView = UIAlertController(title: "Add New Item", message: "Would like to add", preferredStyle:.alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
           // let item = Item()
            let item = Item(context: self.context)
            item.title = textFiled.text ?? "Dd"
            item.done = false
            item.parentcategory = self.selectedCategory
          //  print("Success.",)
            self.itemArr.append(item)
            self.saveItem()
        
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
    
    // MARK: - Model manupulation
    func saveItem() {
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
    
    func loadItem(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        
//        let fetchReq : NSFetchRequest<Item> = Item.fetchRequest()

        /*
        do {
            let decode =  PropertyListDecoder()
            let path = try Data(contentsOf: fileManager!)
           itemArr =  try decode.decode([Item].self, from: path)
        } catch {
            
        }
         */
        
        // 2 method
//        do {
//            itemArr =  try context.fetch(request)
//        } catch {
//            print(error)
//        }
//        print("Count",itemArr.count,itemArr)

        // 3 method
        
        let categoryPredicate = NSPredicate(format: "parentcategory.name MATCHES %@", selectedCategory!.name!)
//        let componentPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
//
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArr =  try context.fetch(request)
        } catch {
            print(error)
        }
        print("Count",itemArr.count,itemArr)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
         
}

extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(itemArr.count)
        return itemArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Cell
        let item = itemArr[indexPath.row]
        cell.title.text = item.title
        cell.selectionStyle = .none
        cell.accessoryType = item.done ? .checkmark : .none
       // item.done? cell.accessoryType = .checkmark : cell.accessoryType = .none
        //let check =  itemArr[indexPath.row].done =  !itemArr[indexPath.row].done
        
        
        return cell
    }
    
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArr[indexPath.row].done =  !itemArr[indexPath.row].done
        saveItem()
        tableView.reloadData()
        //  tableView.deselectRow(at: indexPath, animated: true)
        
        //        if itemArr[indexPath.row].done == true {
        //            itemArr[indexPath.row].done = false
        //        } else {
        //            itemArr[indexPath.row].done = true
        //        }
        // tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        
        //  itemArr[indexPath.row].done  = true
        // reload the row to update the view
        //     tableView.reloadRows(at: [indexPath], with: .none)
    }
}
extension ViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(searchBar.text!)
        
        let req : NSFetchRequest<Item> =  Item.fetchRequest()
        
        let predicate =  NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text ?? "")
        req.predicate = predicate
        req.sortDescriptors =  [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItem(with: req,predicate: predicate)
//        do {
//            itemArr = try! context.fetch(req)
//            tableView.reloadData()
//        } catch {
//            print("e",error)
//        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItem()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()

            }
        } else {
            
            searchBarSearchButtonClicked(searchBar)
        }
    }
}
