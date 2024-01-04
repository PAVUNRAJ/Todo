//
//  SwipeTableViewVC.swift
//  TodoList
//
//  Created by PavunRaj on 04/01/24.
//

import UIKit
import SwipeCellKit

class SwipeTableViewVC: UITableViewController , SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
        cell.delegate = self
        return cell
    }


    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            print("Delete 11")
            self.updateDataModel(at: indexPath)
         //   let commit = self.categoryArr[indexPath.row]
//            self.context.delete(commit)
//            self.categoryArr.remove(at: indexPath.row)
//           // tableView.deleteRows(at:[indexPath], with: .fade)
//
//            self.saveCategory()
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
    
    
    func updateDataModel(at indexpath:IndexPath) {
        print("Daleted")
    }
    
}
