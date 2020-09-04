//
//  CatageoryType.swift
//  Today List
//
//  Created by sojo mathai on 2020-07-23.
//  Copyright © 2020 sojo mathai. All rights reserved.
//

import Foundation
import RealmSwift

class CatageoryType: Object {
    
    @objc dynamic var itemName: String = ""
    @objc dynamic var colourForCell: String = ""
    
    let items = List<ListToDo>()
    
    
}
