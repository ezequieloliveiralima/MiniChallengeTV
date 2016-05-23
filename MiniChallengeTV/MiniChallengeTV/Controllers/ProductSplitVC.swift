//
//  ProductSplitVC.swift
//  MiniChallengeTV
//
//  Created by William Cho on 5/23/16.
//  Copyright © 2016 BEPiD. All rights reserved.
//

import UIKit

class ProductSplitVC: UISplitViewController {
    
    var productId: Int! {
        didSet {
            MainConnector.getProductOffers(productId, params: []) { (productOffers) in
                let vc = self.viewControllers
                let master = (vc[0] as! UINavigationController).viewControllers[0] as! ProductSpecificationVC
                let detail = (vc[1] as! UINavigationController).viewControllers[0] as! ProductDetailVC
                
                master.productOffers = productOffers
                detail.productOffers = productOffers
            }
        }
    }
    
    
}
