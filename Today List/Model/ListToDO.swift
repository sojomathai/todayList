//
//  ListToDO.swift
//  Today List
//
//  Created by sojo mathai on 2020-07-23.
//  Copyright © 2020 sojo mathai. All rights reserved.
//

import Foundation
import RealmSwift

class ListToDo: Object {
    
    @objc dynamic var title: String = ""
    @objc dynamic var finish: Bool = false
    @objc dynamic var date: Date?
    
    var parentCategeory = LinkingObjects(fromType: CatageoryType.self, property: "items")
    
}
