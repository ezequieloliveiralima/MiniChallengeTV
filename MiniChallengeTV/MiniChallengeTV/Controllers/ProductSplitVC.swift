//
//  ProductSplitVC.swift
//  MiniChallengeTV
//
//  Created by William Cho on 5/23/16.
//  Copyright © 2016 BEPiD. All rights reserved.
//

import UIKit

class ProductSplitVC: UISplitViewController {
    
    var product: Product! {
        didSet {
            let vc = self.viewControllers
            let master = (vc[0] as! UINavigationController).viewControllers[0] as! SpecificationsVC
            let detail = (vc[1] as! UINavigationController).viewControllers[0] as! ProductVC
            
            master.product = product
            detail.product = product
        }
    }
    
    
}
