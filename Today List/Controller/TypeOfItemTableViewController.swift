//
//  TypeOfItemTableViewController.swift
//  Today List
//
//  Created by sojo mathai on 2020-07-15.
//  Copyright © 2020 sojo mathai. All rights reserved.
//

import UIKit
import ChameleonFramework
import RealmSwift


class TypeOfItemTableViewController: SwipeViewTableViewController{
    
    let realm = try! Realm()

    var categeoryArray: Results<CatageoryType>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 59
        loadItemsDb()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
         guard let navBar = navigationController?.navigationBar else{fatalError("Error In the Navigation Bar ")}
        let hexColourCatch = "#cceabb"
        
        let bar = UINavigationBarAppearance()
        
        bar.backgroundColor = UIColor(hexString: hexColourCatch)
        navBar.standardAppearance = bar
        navBar.compactAppearance = bar
        navBar.scrollEdgeAppearance = bar
        
        navBar.tintColor = ContrastColorOf(UIColor(hexString: hexColourCatch)!, returnFlat: true)
            
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categeoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reuseCell = super.tableView(tableView, cellForRowAt: indexPath)
    
        if let arrayItem = categeoryArray?[indexPath.row]{
            
            guard let categeroryColo = UIColor(hexString: arrayItem.colourForCell) else{fatalError("ERROR IN COlour")}
            
            reuseCell.textLabel?.text = arrayItem.itemName
            reuseCell.backgroundColor = categeroryColo
            
            reuseCell.textLabel?.textColor = ContrastColorOf(categeroryColo, returnFlat: true)
        }
      
        
        return reuseCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToListArray", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segue1 = segue.destination as! ListToDOTableViewController
        
        if let indexpath2 = tableView.indexPathForSelectedRow{
            
            segue1.segueComing = categeoryArray?[indexpath2.row]
        }
        
    }
    
    @IBAction func cateAddButtonPressed(_ sender: UIBarButtonItem) {
        
        var textRetruns = UITextField()
        
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        let actionItem = UIAlertAction(title: "Add Item", style: .default) { (action) in
            do{
                try self.realm.write{
            let newCateg = CatageoryType()
            newCateg.itemName = textRetruns.text!
                    newCateg.colourForCell = UIColor.randomFlat().hexValue()
                    self.realm.add(newCateg)
            }
            }catch{
                print(error)
            }
            self.tableView.reloadData()
        
//            self.saveData()
            //self.loadItemsDb()
            
        }
        alert.addAction(actionItem)
        alert.addTextField { (alretText1) in
            alretText1.placeholder = "Add Category Item"
            textRetruns = alretText1
        }
        present(alert, animated: true, completion: nil)
        
        
    }
    
    func saveData(){
        do{
            try realm.write{
                realm.add(categeoryArray!)
            }
        }catch{
            
            print("Error When SAving data\(error)")
        }
        
        tableView.reloadData()
    }
    func loadItemsDb(){
        
        categeoryArray = realm.objects(CatageoryType.self)
        tableView.reloadData()

    }
    override func updateModel(at indexpath: IndexPath) {
        
        if let currentDeleation = categeoryArray?[indexpath.row]{
            
                    do{
                        try realm.write{
            
                            realm.delete(currentDeleation)
                        }
                    }catch{
                        print("error in deleting the items \(error)")
                    }

        }
//



    }
}

