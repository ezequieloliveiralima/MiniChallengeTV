//
//  LocalStorage.swift
//  MiniChallengeTV
//
//  Created by Ezequiel de Oliveira Lima on 20/05/16.
//  Copyright © 2016 BEPiD. All rights reserved.
//

import UIKit

class SavedProduct {
    var id: Int!
    var name: String!
    var thumbnail: String!
}

class LocalStorage {
    private static let maxHistoricItems = 30

    class func addFavorite(product: Product) {
        let predicate = NSPredicate(format: "SELF.id == %@", NSNumber(integer: product.id))
        let item = CoreDataManager
            .instance.query("CDFavoriteItem", predicate: predicate) as! [CDFavoriteItem]
        if item.count == 0 {
            let newFavorite = CoreDataManager.instance.create("CDFavoriteItem") as! CDFavoriteItem
            
            newFavorite.id = NSNumber(integer: product.id)
            newFavorite.name = product.name
            newFavorite.thumbnail = product.thumbnails?.first?.url
            
            CoreDataManager.instance.save()
        }
    }
    
    class func isFavorite(product: Product) -> Bool {
        let predicate = NSPredicate(format: "SELF.id == %@", NSNumber(integer: product.id))
        let item = CoreDataManager.instance.query("CDFavoriteItem", predicate: predicate)
        return item.count == 1
    }
    
    class func removeFavorite(product: Int) {
        let predicate = NSPredicate(format: "SELF.id == %@", NSNumber(integer: product))
        let item = CoreDataManager
            .instance.query("CDFavoriteItem", predicate: predicate)
        CoreDataManager.instance.delete(item.first!)
    }
    
    class func registryHistoric(product: Product) {
        let registredItems = CoreDataManager.instance.all("CDHistoricItem")
        
        let predicate = NSPredicate(format: "SELF.id = %@", NSNumber(integer: product.id))
        if CoreDataManager.instance.query("CDHistoricItem", predicate: predicate).count == 0 {
            let newEntry = CoreDataManager.instance.create("CDHistoricItem") as! CDHistoricItem
            
            newEntry.id = NSNumber(integer: product.id)
            newEntry.name = product.name
            newEntry.thumbnail = product.thumbnails?.first?.url
            
            if registredItems.count >= maxHistoricItems {
                let first = registredItems.first
                CoreDataManager.instance.delete(first!)
            }
            
            CoreDataManager.instance.save()
        }
    }
    
    class func fetchHistoric() -> [SavedProduct] {
        var productList: [SavedProduct]! = []
        let historic = CoreDataManager.instance.all("CDHistoricItem") as! [CDHistoricItem]
        
        historic.forEach { (item) in
            let p = SavedProduct()
            p.id = item.id?.integerValue
            p.name = item.name
            p.thumbnail = item.thumbnail
            productList.append(p)
        }
        
        return productList
    }
    
    class func fetchFavorites() -> [SavedProduct] {
        var productList: [SavedProduct]! = []
        let historic = CoreDataManager.instance.all("CDFavoriteItem") as! [CDFavoriteItem]
        
        historic.forEach { (item) in
            let p = SavedProduct()
            p.id = item.id?.integerValue
            p.name = item.name
            p.thumbnail = item.thumbnail
            productList.append(p)
        }
        
        return productList
    }
    
//    class func fetchCategories() -> [AnyObject] {
//        var list = [AnyObject]()
//        CoreDataManager.instance.all("").forEach { (cdObject) in
//            list.append("")
//        }
//        return list
//    }
    
//    class func addCategory() {
//        let newCategory = CoreDataManager.instance.create("")
//        CoreDataManager.instance.save()
//    }
}