//
//  MainController.swift
//  MiniChallengeTV
//
//  Created by William Cho on 5/19/16.
//  Copyright © 2016 BEPiD. All rights reserved.
//

import UIKit

class MainController: NSObject, MainDelegate {
    
    private let connector: BuscapeConnector
    
    override init() {
        connector = BuscapeConnector()
        super.init()
    }
    
//    func getList(of: SearchType, params: SearchParameter..., callback: (List<Product>) -> Void) {
//        
//    }
    
    func getListTopProducts(params: SearchParameter..., callback: (List<Product>) -> Void) {
        connector.getList(.TopProducts, parameters: []) { (list: BList<BProduct>) in
            callback(List<Product>(list: list))
        }
    }
    
    func getListProducts(params: SearchParameter..., callback: (List<Product>) -> Void) {
        connector.getList(.Product, parameters: params) { (list: BList<BProduct>) in
            callback(List<Product>(list: list))
        }
    }
    
    func getListTopCategories(params: SearchParameter..., callback: (List<Category>) -> Void) {
        connector.getList(.TopCategories, parameters: params) { (list: BList<BCategory>) in
            callback(List<Category>(list: list))
        }
    }
    
    func getListCategories(params: SearchParameter..., callback: (List<Category>) -> Void) {
        connector.getList(.Category, parameters: params) { (list: BList<BCategory>) in
            callback(List<Category>(list: list))
        }
    }
    
    func getListOffers(params: SearchParameter..., callback: (List<Offer>) -> Void) {
        connector.getList(.Offer, parameters: params) { (list: BList<BOffer>) in
            callback(List<Offer>(list: list))
        }
    }
    
    func getHistory(callback: () -> Void) {
        callback()
    }
    
    func getFavorites(callback: () -> Void) {
        callback()
    }
    
}

extension MainController: UINavigationControllerDelegate {
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        
    }
    
}


protocol MainDelegate {
    
    func getListTopProducts(params: SearchParameter..., callback: (List<Product>) -> Void)
    func getListProducts(params: SearchParameter..., callback: (List<Product>) -> Void)
    
    func getListTopCategories(params: SearchParameter..., callback: (List<Category>) -> Void)
    func getListCategories(params: SearchParameter..., callback: (List<Category>) -> Void)
  
    func getHistory(callback: () -> Void)
    
    func getFavorites(callback: () -> Void)
    
    
//    func addFavorite()
//    func removeFavorite()
    
}