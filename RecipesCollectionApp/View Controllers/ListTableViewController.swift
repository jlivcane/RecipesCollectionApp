//
//  ListTableViewController.swift
//  RecipesCollectionApp
//
//  Created by jekaterina.livcane on 11/09/2020.
//  Copyright © 2020 jekaterina.livcane. All rights reserved.
//

import UIKit
import CoreData

class ListTableViewController: UITableViewController {
    
    var recipesCollection = ["https://www.jamieoliver.com/recipes/pork-recipes/good-old-lasagne/",
                             "https://www.jamieoliver.com/recipes/vegetable-recipes/simple-houmous/",
                             "https://www.allrecipes.com/recipe/222000/spaghetti-aglio-e-olio/",
                             "https://www.jamieoliver.com/recipes/bread-recipes/basic-pizza/",
                             "https://www.recipetineats.com/homemade-chicken-doner-kebab/",
                             "hhttps://natashaskitchen.com/tender-beef-kebabs-shashlik-recipe/"
    ]
    
    var context: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        loadData()
        
    }
    @IBAction func addNewItemTapped(_ sender: Any) {
        addNewRecipe()
    }
    
    func addNewRecipe(){
        
        let alertController = UIAlertController(title: "Recipes!", message: "Please add recipe", preferredStyle: .alert)
        alertController.addTextField { (textField: UITextField) in
        }
        //add button
        let addAction = UIAlertAction(title: "Add", style: .cancel) { (action: UIAlertAction) in
            let textField = alertController.textFields?.first
            
            let entity = NSEntityDescription.entity(forEntityName: "RecipesCollection", in: self.context!)
            let recipe = NSManagedObject(entity: entity!, insertInto: self.context)
            recipe.setValue(textField?.text, forKey: "recipe")
            
           // self.savingChanges(message: "Error to store Recipe")
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    func loadData(){
        
        let request: NSFetchRequest<RecipesCollection> = RecipesCollection.fetchRequest()
        do{
            let result = try context!.fetch(request)
            recipesCollection = 
                tableView.reloadData()
        }catch{
            fatalError("Error in retrieving recipes")
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return recipesCollection.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "webCell", for: indexPath)
        
        let recipe = recipesCollection[indexPath.row]
        cell.textLabel?.text = recipesCollection[indexPath.row](forKey: "recipe") as? String
        cell.selectionStyle = .none
        
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let alert = UIAlertController(title: "Delete?", message: "Are you sure upi want to delete?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                
                alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (_) in
            let recipe = self.recipesCollection[indexPath.row]
            self.recipesCollection.remove(at: indexPath.row)
            
            //self.context?.delete(recipe)
            tableView.reloadRows(at: [indexPath], with: .automatic)
            self.saveData()
        }))
            
        self.present(alert, animated: true)
            
        } else if editingStyle == .insert {
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
        
        
    }
    
    
    
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: WebViewController = storyBoard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        vc.passedValue = recipesCollection[indexPath.row]
        self.present(vc, animated: true)
    }
    
}

