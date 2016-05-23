//
//  LocalStorage.swift
//  MiniChallengeTV
//
//  Created by Ezequiel de Oliveira Lima on 20/05/16.
//  Copyright © 2016 BEPiD. All rights reserved.
//

import UIKit


class LocalStorage {
    func addFavorite() {
        let item = CoreDataManager
            .instance.query("", predicate: NSPredicate(format: "SELF.id == %@", ""))
        if item.count == 0 {
            let newFavorite = CoreDataManager.instance.create("")
            CoreDataManager.instance.save()
        }
    }
    
    func removeFavorite(id: Int) {
        let item = CoreDataManager
            .instance.query("", predicate: NSPredicate(format: "SELF.id == %@", id))
        CoreDataManager.instance.delete(item.first!)
    }
    
    func registryHistoric() {
        let registredItems = CoreDataManager.instance.all("")
        
        if registredItems.count == 30 {
            let first = registredItems.first
            CoreDataManager.instance.delete(first!)
        }
        
        if CoreDataManager.instance.query("", predicate: NSPredicate(format: "SELF.id == %@", "")).count == 0 {
            let newEntry = CoreDataManager.instance.create("")
            CoreDataManager.instance.save()
        }
    }
    
    func fetchCategories() -> [AnyObject] {
        var list = [AnyObject]()
        CoreDataManager.instance.all("").forEach { (cdObject) in
            list.append("")
        }
        return list
    }
    
    func addCategory() {
        let newCategory = CoreDataManager.instance.create("")
        CoreDataManager.instance.save()
    }
}