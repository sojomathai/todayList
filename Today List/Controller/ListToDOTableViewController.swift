//
//  ListToDOTableViewController.swift
//  Today List
//
//  Created by sojo mathai on 2020-07-14.
//  Copyright © 2020 sojo mathai. All rights reserved.
//

import UIKit
import CoreData

class ListToDOTableViewController: UITableViewController {
    
    var textFiled = UITextField()
    
    var listArray = [ListToDO]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadTable()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reuseCell = tableView.dequeueReusableCell(withIdentifier: "listTable", for: indexPath)
        let item = listArray[indexPath.row]
        
        reuseCell.textLabel?.text = item.title
       
        return reuseCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        context.delete(listArray[indexPath.row])
//        listArray.remove(at: indexPath.row)
        saveAraayData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alret = UIAlertController.init(title: "Add a List", message: "", preferredStyle: .alert)
        let action = UIAlertAction.init(title: "Add Item", style: .default) { (action) in
            
            let newListItem = ListToDO(context: self.context)
            
            newListItem.title = self.textFiled.text
            self.listArray.append(newListItem)
            self.saveAraayData()
//            self.reloadTable()
            
        }
        
        alret.addAction(action)
        alret.addTextField { (alretText) in
            alretText.placeholder = "Add List"
            self.textFiled = alretText
        }
        present(alret, animated: true, completion: nil)
    }
    
    func reloadTable(with request: NSFetchRequest<ListToDO> = ListToDO.fetchRequest()){
        
        do{
        listArray = try context.fetch(request)
        }catch{
            print("Error in the fetch the requested item\(error)")
        }
        
        //tableView.reloadData()
    }
    
    func saveAraayData(){
        do{
        try context.save()
        }catch{
            print("Error in saving the dqat \(error)")
        }
        tableView.reloadData()
    }

}
