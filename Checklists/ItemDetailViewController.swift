//
//  itemDetailViewController.swift
//  Checklists
//
//  Created by LeeDavid on 9/18/16.
//  Copyright © 2016 Daylight. All rights reserved.
//

import UIKit


protocol itemDetailViewControllerDelegate: class {
    func itemDetailViewControllerDidCancel(controller: itemDetailViewController)
    
    func itemDetailViewController(controller: itemDetailViewController, didFinishAddingItem item: ChecklistItem)
    
    func itemDetailViewController(controller: itemDetailViewController, didFinishEditingItem item: ChecklistItem)
}


class itemDetailViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    weak var delegate: itemDetailViewControllerDelegate?
    var itemToEdit: ChecklistItem?
    
    
    @IBAction func done() {
        if let item = itemToEdit {
            item.text = textField.text!
            delegate?.itemDetailViewController(controller: self, didFinishEditingItem: item)
        } else {
            let item = ChecklistItem()
            item.text = textField.text!
            item.checked = false
            delegate?.itemDetailViewController(controller: self, didFinishAddingItem: item)
        }
        
        
    }
    
    @IBAction func cancel() {
        delegate?.itemDetailViewControllerDidCancel(controller: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = itemToEdit {
            title = "Edit Item"
            textField.text = item.text
            doneBarButton.isEnabled = true
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let oldText: NSString = textField.text! as NSString
        let newText: NSString = oldText.replacingCharacters(in: range, with: string) as NSString

        doneBarButton.isEnabled = (newText.length > 0)
        
        return true
    }
    
}












