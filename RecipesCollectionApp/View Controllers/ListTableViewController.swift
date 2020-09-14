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
    var links = [RecipesCollection]()
    
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
            links = result
            tableView.reloadData()
        }catch{
            fatalError("Error in retrieving recipes")
        }
    }
    func saveData(){
        do{
            try self.context?.save()
        }catch{
            fatalError(error.localizedDescription)
        }
        loadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return recipesCollection.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "webCell", for: indexPath)
        let link = links[indexPath.row]
        cell.textLabel?.text = link.value(forKey: "recipe") as? String
        cell.textLabel?.numberOfLines = 0
        cell.selectionStyle = .none
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: "Delete?", message: "Are you sure upi want to delete?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (_) in
                self.context?.delete(self.links[indexPath.row])
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }))
            self.present(alert, animated: true)
        }
        self.saveData()
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: WebViewController = storyBoard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        vc.passedValue = recipesCollection[indexPath.row]
        self.present(vc, animated: true)
    }
    
}

