//
//  AddGroceryViewController.swift
//  GroceryListApp
//
//  Created by Mahrukh khan on 8/31/19.
//  Copyright © 2019 Mahrukh khan. All rights reserved.
//

import UIKit
import CoreData

class AddGroceryViewController: UIViewController {
    
    var managedContext: NSManagedObjectContext!
   
    @IBOutlet weak var viewAdd: UIView!
    
    @IBOutlet weak var titleaddITem: UILabel!
    var groceryItem : String = " "
    
      override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
      
        self.view.backgroundColor = UIColor.black.withAlphaComponent( 0.8)
    }
    
    @IBOutlet weak var itemOutlet: UITextField!
    
    
    @IBAction func save(_ sender: UIButton) {
     
        guard let groceryItem = itemOutlet.text, !groceryItem.isEmpty else{
        return
        }
        let groceryTodo = GroceryToDo(context: managedContext)
        groceryTodo.groceryItem = groceryItem
        
        
        do {
            try managedContext.save()
              dismiss(animated: true)
            itemOutlet.resignFirstResponder()
             
        } catch {
            print("Error saving toDo \(error)")
        }
        
    }
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true)
        itemOutlet.resignFirstResponder()
 
    }
}
