//
//  ChecklistItem.swift
//  Checklists
//
//  Created by LeeDavid on 9/17/16.
//  Copyright © 2016 Daylight. All rights reserved.
//

import Foundation


class ChecklistItem: NSObject, NSCoding {
    
    var text = ""
    var checked = false
    
    // required: ???
    override init() {
        super.init()
    }
    
    // required: decode data
    required init?(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObject(forKey: "Text") as! String
        checked = aDecoder.decodeBool(forKey: "Checked")
        super.init()
    }
    
    
    func toggleChecked() {
        checked = !checked
    }
    
    
    // required: encode data
    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: "Text")
        aCoder.encode(checked, forKey: "Checked")
    }
    
    
}























