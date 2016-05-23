//
//  MainController.swift
//  MiniChallengeTV
//
//  Created by William Cho on 5/19/16.
//  Copyright © 2016 BEPiD. All rights reserved.
//

import UIKit

class MainConnector {
    private static let connector = BuscapeConnector()
    
    
//    func getList(of: SearchType, params: SearchParameter..., callback: (List<Product>) -> Void) {
//        
//    }
    
    class func getListTopProducts(params: [SearchParameter], callback: (List<Product>) -> Void) {
        connector.getList(.TopProducts, parameters: []) { (list: BList<BProduct>) in
            callback(List<Product>(list: list))
        }
    }
    
    class func getListProducts(params: [SearchParameter], callback: (List<Product>) -> Void) {
        connector.getList(.Product, parameters: params) { (list: BList<BProduct>) in
            callback(List<Product>(list: list))
        }
    }
    
    class func getListTopCategories(params: [SearchParameter], callback: (List<Category>) -> Void) {
        connector.getList(.TopCategories, parameters: params) { (list: BList<BCategory>) in
            callback(List<Category>(list: list))
        }
    }
    
    class func getListCategories(params: [SearchParameter], callback: (List<Category>) -> Void) {
        connector.getList(.Category, parameters: params) { (list: BList<BCategory>) in
            callback(List<Category>(list: list))
        }
    }
    
    class func getListOffers(params: [SearchParameter], callback: (List<Offer>) -> Void) {
        connector.getList(.Offer, parameters: params) { (list: BList<BOffer>) in
            callback(List<Offer>(list: list))
        }
    }
    
    class func getProductOffers(product: Product, params: [SearchParameter], callback: (List<Offer>) -> Void) {
        var params = params
        params.append(SearchParameter.ProductId(product.id))
        connector.getList(.Offer, parameters: params) { (list: BList<BOffer>) in
            callback(List<Offer>(list: list))
        }
    }
    
    class func getHistory(callback: ([SavedProduct]) -> Void) {
        callback(LocalStorage.fetchHistoric())
    }
    
    class func getFavorites(callback: ([SavedProduct]) -> Void) {
        callback(LocalStorage.fetchFavorites())
    }
    
    class func getImage(url: String, callback: (UIImage?) -> Void) {
        ConnectionManager.getImage(url, completionHandler: callback)
    }
    
    class func registryHistoric(product: Product) {
        LocalStorage.registryHistoric(product)
    }
    
    class func addFavorite(product: Product, callback: (()->Void)?) {
        LocalStorage.addFavorite(product)
        callback?()
    }
    
    class func removeFavorite(product: Int, callback: (()->Void)?) {
        LocalStorage.removeFavorite(product)
        callback?()
    }
    
    class func isFavorite(product: Product, callback: (Bool)->Void) {
        callback(LocalStorage.isFavorite(product))
    }
}