//
//  Category.swift
//  Todoey
//
//  Created by G. A. KAMPHUIS on 15/05/2018.
//  Copyright © 2018 GAKKIE. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    
    //setup relationship to items (one-to-many). Initialise an empty List of Item objects
    let items = List<Item>()
    
}
