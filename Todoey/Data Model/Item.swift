//
//  Item.swift
//  Todoey
//
//  Created by G. A. KAMPHUIS on 15/05/2018.
//  Copyright © 2018 GAKKIE. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    //@objc dynamic before the variables is needed so that Realm can monitor for changes in Real time!
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date = Date()
    
    //setup relationship (to one), reverse relationship
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items") //Item.self refers to the Type rather that the object/instance!
}
