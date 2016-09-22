//
//  ViewController.swift
//  Checklists
//
//  Created by LeeDavid on 9/17/16.
//  Copyright © 2016 Daylight. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
    
    var items = [ChecklistItem]()
    var checklist: Checklist!
    
//    required init?(coder aDecoder: NSCoder) {
//        items = [ChecklistItem]()
//        
//        super.init(coder: aDecoder)
//        
//        loadChecklistItems()
        
//        print("Documents folder is \(documentsDirectory())")
//        print("Data file path is \(dataFilePath())")
//    }
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = checklist.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
        let item = checklist.items[indexPath.row]
        
        configureTextForCell(cell: cell, withChecklistItem: item)
        configureCheckmarkForCell(cell: cell, withChecklistItem: item)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = checklist.items[indexPath.row]

            item.toggleChecked()
            configureCheckmarkForCell(cell: cell, withChecklistItem: item)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        // save check status
//        saveChecklistItems()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        // delete from Data
        items.remove(at: indexPath.row)
        
        // delete from View
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
        // save applying deleted items
//        saveChecklistItems()
    }
    
    
    func configureCheckmarkForCell(cell: UITableViewCell, withChecklistItem item: ChecklistItem) {
        
        let label = cell.viewWithTag(1001) as! UILabel
        if item.checked {
            label.text = "😀"
        } else {
            label.text = ""
        }
    }
    
    func configureTextForCell(cell: UITableViewCell, withChecklistItem item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    func itemDetailViewControllerDidCancel(controller: ItemDetailViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func itemDetailViewController(controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem) {
        
        let newRowIndex = checklist.items.count
        checklist.items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        
        dismiss(animated: true, completion: nil)
        
//        saveChecklistItems()
    }
    
    func itemDetailViewController(controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem) {
        
        // index(of:) must conform to NSObject
        if let index = checklist.items.index(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureTextForCell(cell: cell, withChecklistItem: item)
            }
        }
        
        dismiss(animated: true, completion: nil)
        
//        saveChecklistItems()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addItem" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            
            controller.delegate = self
        } else if segue.identifier == "editItem" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            
            controller.delegate = self
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = checklist.items[indexPath.row]
            }
        }
    }
    
    
//    func documentsDirectory() -> String {
//        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
//        return paths[0]
//    }
//    
//    func dataFilePath() -> String {
//        return "\(documentsDirectory())/Checklists.plist"
//    }
//    
//    
//    func saveChecklistItems() {
//        let data = NSMutableData()
//        let archiver = NSKeyedArchiver(forWritingWith: data)
//        archiver.encode(items, forKey: "ChecklistItems")
//        archiver.finishEncoding()
//        data.write(toFile: dataFilePath(), atomically: true)
//    }
//    
//    
//    func loadChecklistItems() {
//        let path = dataFilePath()
//        if FileManager.default.fileExists(atPath: path) {
//            if let data = NSData(contentsOfFile: path) {
//                let unarchiver = NSKeyedUnarchiver(forReadingWith: data as Data)
//                items = unarchiver.decodeObject(forKey: "ChecklistItems") as! [ChecklistItem]
//                unarchiver.finishDecoding()
//            }
//        }
//    }
    
    
}














