//
//  Category.swift
//  Mandarin
//
//  Created by Macostik on 12/5/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import Foundation
import RealmSwift

extension Object {
    static func getObject(by id: Int) -> Object? {
        let realm = try! Realm()
        guard let object = realm.objects(self).filter("id == \(id)").first else { return nil }
        return object
    }
}

extension Results {
    func array<T>(ofType: T.Type) -> [T] {
        return flatMap { $0 as? T }
    }
}

class Category: Object {
    
    dynamic var id = ""
    dynamic var icon = ""
    dynamic var name = ""
    dynamic var created_at = ""
    dynamic var units = ""
    dynamic var category_id = ""
    dynamic var image: Data? = nil
    
    static func setConfig() {
        let realm = try! Realm()
        if let url = realm.configuration.fileURL {
            print("FileURL of DataBase - \(url)")
        }
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    @discardableResult class func setupCategory(id: String = "",
                             icon: String = "",
                             name: String = "",
                             created_at: String = "",
                             units: String = "",
                             category_id: String = "",
                             image: Data? = nil) -> Category {
        
        let categoryData: Dictionary<String, Any> = [
            "id" :          id,
            "icon" :   icon,
            "name" :    name,
            "created_at" :       created_at,
            "units" :       units,
            "category_id" : category_id,
            "image" : image ?? Data()]
        
        let category = Category(value: categoryData)
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(category, update: true)
        }
        return category
    }
    
    static var allCategories: [Category] = {
        let realm = try! Realm()
        return realm.objects(Category.self).array(ofType: Category.self)
    }()
}

