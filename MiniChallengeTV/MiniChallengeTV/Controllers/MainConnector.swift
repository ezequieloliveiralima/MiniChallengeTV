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
    
    class func getHistory(callback: () -> Void) {
        callback()
    }
    
    class func getFavorites(callback: () -> Void) {
        callback()
    }
    
    class func getImage(url: String, callback: (UIImage?) -> Void) {
        ConnectionManager.getImage(url, completionHandler: callback)
    }
}