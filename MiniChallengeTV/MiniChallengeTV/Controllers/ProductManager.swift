//
//  ProductManager.swift
//  MiniChallengeTV
//
//  Created by William Cho on 5/17/16.
//  Copyright © 2016 BEPiD. All rights reserved.
//

import Foundation

class ProductManager {
    
    private static let connector = BuscapeConnector()
    
    class func getTopOffers() {
        connector.getTopOffers { (list) in
            
        }
    }
    
    class func getTopCategories() {
        
    }
    
    class func getTopProducts() {
        
    }
    
    class func getOffers() {
        
    }
}

private extension ProductManager {
    
}