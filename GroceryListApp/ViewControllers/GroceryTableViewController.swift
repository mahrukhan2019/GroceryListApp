//
//  GroceryTableViewController.swift
//  GroceryListApp
//
//  Created by Mahrukh khan on 8/31/19.
//  Copyright © 2019 Mahrukh khan. All rights reserved.
//

import UIKit
import CoreData

class GroceryTableViewController: UITableViewController { 

    
    // MARK: - PROPERTIES
    
    var resultController: NSFetchedResultsController<GroceryToDo>!
    let coreDataStack = CoreDataStack()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        let request: NSFetchRequest<GroceryToDo> = GroceryToDo.fetchRequest()
        let sortDescriptors = NSSortDescriptor(key: "groceryItem", ascending: false
        )
        request.sortDescriptors = [sortDescriptors]
    resultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: coreDataStack.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        resultController.delegate = self
        
        do {
           try resultController.performFetch()
        } catch {
            print("Perform fetch data \(error)")
        }
    
    }
   
    
    @IBAction func showPopup(_ sender: Any) {
        let popOverVC = UIStoryboard (name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popViewID") as! AddGroceryViewController
        
        self.addChild(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)
    }
 
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
       
        return resultController.sections?[section].objects?.count ?? 0
        //return groceries.count
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            //todo
            let groctoDO = self.resultController.object(at: indexPath)
            self.resultController.managedObjectContext.delete(groctoDO)
            
            do {
                try self.resultController.managedObjectContext.save()
                  completion(true)
            } catch {
            print("delete failed \(error)")
                  completion(false)
            }
          
        }
        action.backgroundColor = UIColor.red
        return UISwipeActionsConfiguration(actions: [action])
        
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! groceryTableViewCell
        let groceryTodo = resultController.object(at: indexPath)
        cell.itemCell.text = groceryTodo.groceryItem
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! groceryTableViewCell
        
       // cell.itemCell.text = groceries[indexPath.row].groceryItem
        
        return cell
    }
    

    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
        if let _ = sender as? UIBarButtonItem, let vc = segue.destination as? AddGroceryViewController{
            vc.managedContext = resultController.managedObjectContext
            
         
        }
    
}
}


extension GroceryTableViewController: NSFetchedResultsControllerDelegate{
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath{
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath{
                tableView.deleteRows(at: [indexPath], with: .automatic )
            }
        default:
            break
        }
    }
}
