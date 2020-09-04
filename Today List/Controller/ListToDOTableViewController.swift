//
//  ListToDOTableViewController.swift
//  Today List
//
//  Created by sojo mathai on 2020-07-14.
//  Copyright © 2020 sojo mathai. All rights reserved.
//

import UIKit
import ChameleonFramework

import RealmSwift

class ListToDOTableViewController: SwipeViewTableViewController {
    
    @IBOutlet weak var searchBarCol: UISearchBar!
    
    let realm = try! Realm()
    
    var textFiled = UITextField()
    
    var listArray: Results<ListToDo>?
    
    var segueComing: CatageoryType?{
        
        didSet{
            reloadTable()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        
        
        reloadTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let colourFromSeg = segueComing?.colourForCell{
            
            title = segueComing?.itemName
            
            
            guard let navBar = navigationController?.navigationBar else{fatalError("Error In the Navigation Bar ")}
            if let hexColourCatch = UIColor(hexString: colourFromSeg){
                //navBar.barTintColor = hexColourCatch
                //navBar.backgroundColor = hexColourCatch
                
                let bar = UINavigationBarAppearance()
                bar.backgroundColor = hexColourCatch
                
                navBar.standardAppearance = bar
                navBar.compactAppearance = bar
                navBar.scrollEdgeAppearance = bar
                
                navBar.tintColor = ContrastColorOf(hexColourCatch, returnFlat: true)
                searchBarCol.backgroundColor =  hexColourCatch
                searchBarCol.barTintColor = hexColourCatch
                navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(hexColourCatch, returnFlat: true)]
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = listArray?[indexPath.row]{
            
            cell.textLabel?.text = item.title
            
            if let colour = UIColor(hexString: segueComing!.colourForCell)!.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(listArray!.count)){
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
                
                cell.backgroundColor = colour
            }
            
            
            cell.accessoryType = item.finish ? .checkmark : .none
            
            
        }else{
            cell.textLabel?.text = "No task added"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //                context.delete(listArray[indexPath.row])
        //                listArray.remove(at: indexPath.row)
        
        
        if let itemmCheck = listArray?[indexPath.row]{
            
            do{
                try realm.write{
                    itemmCheck.finish = !itemmCheck.finish
                }
            }catch{
                print("Error in Update check\(error)")
            }
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alret = UIAlertController.init(title: "Add a List", message: "", preferredStyle: .alert)
        let action = UIAlertAction.init(title: "Add Item", style: .default) { (action) in
            
            if let currentItems = self.segueComing{
                do{
                    
                    try self.realm.write{
                        let newListItem = ListToDo()
                        newListItem.title = self.textFiled.text!
                        newListItem.date = Date()
                        currentItems.items.append(newListItem)
                    }
                }catch{
                    print("error in  the items adding \(error)")
                    
                }
                
            }
            self.tableView.reloadData()
            
        }
        
        alret.addAction(action)
        alret.addTextField { (alretText1) in
            alretText1.placeholder = "Add List"
            self.textFiled = alretText1
        }
        present(alret, animated: true, completion: nil)
    }
    
    func reloadTable(){
        
        listArray = segueComing?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    override func updateModel(at indexpath: IndexPath) {
        
        if let current = listArray?[indexpath.row]{
            
            do{
                try realm.write{
                    
                    realm.delete(current)
                }
            }catch{
                print("error in deleting the items \(error)")
            }
        }
        
    }
    
    func saveAraayData(){
        
        
        //        do{
        //            try context.save()
        //
        //        }catch{
        //            print("Error in saving the dqat \(error)")
        //        }
        tableView.reloadData()
    }
}

extension ListToDOTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        listArray = listArray?.filter( "title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "date", ascending: true)
        
        tableView.reloadData()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            
            reloadTable()
            
            DispatchQueue.main.async {
                
                searchBar.resignFirstResponder()
            }
        }
    }
    
    
}




