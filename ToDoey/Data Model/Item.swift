//
//  Item.swift
//  ToDoey
//
//  Created by Ofir Elias on 14/07/2019.
//  Copyright © 2019 Ofir Elias. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var isChecked: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
