//
//  Category.swift
//  ToDoey
//
//  Created by Ofir Elias on 14/07/2019.
//  Copyright © 2019 Ofir Elias. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
