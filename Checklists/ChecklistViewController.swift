//
//  ViewController.swift
//  Checklists
//
//  Created by LeeDavid on 9/17/16.
//  Copyright © 2016 Daylight. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController, itemDetailViewControllerDelegate {
    
    var items: [ChecklistItem]
    
    
    required init?(coder aDecoder: NSCoder) {
        items = [ChecklistItem]()
        
//        let row0item = ChecklistItem()
//        row0item.text = "Walk the dog"
//        row0item.checked = false
//        items.append(row0item)
//        
//        let row1item = ChecklistItem()
//        row1item.text = "Brush my teeth"
//        row1item.checked = true
//        items.append(row1item)
//        
//        let row2item = ChecklistItem()
//        row2item.text = "Learn iOS development"
//        row2item.checked = true
//        items.append(row2item)
//
//        let row3item = ChecklistItem()
//        row3item.text = "Soccer practice"
//        row3item.checked = false
//        items.append(row3item)
//        
//        let row4item = ChecklistItem()
//        row4item.text = "Eat ice cream"
//        row4item.checked = true
//        items.append(row4item)
        
        super.init(coder: aDecoder)
        
        loadChecklistItems()
        
//        print("Documents folder is \(documentsDirectory())")
//        print("Data file path is \(dataFilePath())")
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
        let item = items[indexPath.row]
        
        configureTextForCell(cell: cell, withChecklistItem: item)
        configureCheckmarkForCell(cell: cell, withChecklistItem: item)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = items[indexPath.row]

            item.toggleChecked()
            configureCheckmarkForCell(cell: cell, withChecklistItem: item)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        saveChecklistItems()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        // delete from Data
        items.remove(at: indexPath.row)
        
        // delete from View
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
        saveChecklistItems()
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
    
    func itemDetailViewControllerDidCancel(controller: itemDetailViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func itemDetailViewController(controller: itemDetailViewController, didFinishAddingItem item: ChecklistItem) {
        
        let newRowIndex = items.count
        items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        
        dismiss(animated: true, completion: nil)
        
        saveChecklistItems()
    }
    
    func itemDetailViewController(controller: itemDetailViewController, didFinishEditingItem item: ChecklistItem) {
        
        // index(of:) must conform to NSObject
        if let index = items.index(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureTextForCell(cell: cell, withChecklistItem: item)
            }
        }
        
        dismiss(animated: true, completion: nil)
        
        saveChecklistItems()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addItem" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! itemDetailViewController
            
            controller.delegate = self
        } else if segue.identifier == "editItem" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! itemDetailViewController
            
            controller.delegate = self
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = items[indexPath.row]
            }
        }
    }
    
    
    func documentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return paths[0]
    }
    
    func dataFilePath() -> String {
        return "\(documentsDirectory())/Checklists.plist"
    }
    
    
    func saveChecklistItems() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
//        archiver.encodeConditionalObject(items, forKey: "ChecklistItems")
        archiver.encode(items, forKey: "ChecklistItems")
        archiver.finishEncoding()
        data.write(toFile: dataFilePath(), atomically: true)
    }
    
    
    func loadChecklistItems() {
        let path = dataFilePath()
        if FileManager.default.fileExists(atPath: path) {
            if let data = NSData(contentsOfFile: path) {
                let unarchiver = NSKeyedUnarchiver(forReadingWith: data as Data)
                items = unarchiver.decodeObject(forKey: "ChecklistItems") as! [ChecklistItem]
                unarchiver.finishDecoding()
            }
        }
    }
    
    
}














