//
//  ProductSplitVC.swift
//  MiniChallengeTV
//
//  Created by William Cho on 5/23/16.
//  Copyright © 2016 BEPiD. All rights reserved.
//

import UIKit

class ProductSplitVC: UISplitViewController {
    
    var master: ProductSpecificationVC?
    var detail: ProductDetailVC?
    
    var productId: Int! {
        didSet {
            MainConnector.getProductOffers(productId, params: []) { (productOffers) in
                let vc = self.viewControllers
                let master = (vc[0] as! UINavigationController).viewControllers.first as! ProductSpecificationVC
                let detail = (vc[1] as! UINavigationController).viewControllers.first as! ProductDetailVC
                
                self.master = master
                self.detail = detail
                master.productOffers = productOffers
                detail.productOffers = productOffers
            }
        }
    }
    
    
}
