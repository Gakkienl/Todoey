//
//  Item.swift
//  Todoey
//
//  Created by G. A. KAMPHUIS on 09/05/2018.
//  Copyright © 2018 GAKKIE. All rights reserved.
//

import Foundation

//conform to protocol Codable. For a class to be Codable. All properties must be of standard types!
class Item: Codable {
    var titel: String =  ""
    var done: Bool = false
   
    
}
