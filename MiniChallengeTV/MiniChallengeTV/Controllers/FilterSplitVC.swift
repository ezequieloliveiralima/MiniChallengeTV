//
//  FilterSplitVC.swift
//  MiniChallengeTV
//
//  Created by William Cho on 5/23/16.
//  Copyright © 2016 BEPiD. All rights reserved.
//

import UIKit

class FilterSplitVC: UISplitViewController {
    
    var master: FilterOptionsVC?
    var detail: FilterResultsVC?
    
    var searchParameters: [SearchParameter]! {
        didSet {
            MainConnector.getListProducts(searchParameters) { (list) in
                let vc = self.viewControllers
                let master = (vc[0] as! UINavigationController).viewControllers.first as! FilterOptionsVC
                let detail = (vc[1] as! UINavigationController).viewControllers.first as! FilterResultsVC
                
                self.master = master
                self.detail = detail
                detail.container = self
                detail.products = list
            }
        }
    }
    
    func goToProduct() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ProductSplitVC") as! ProductSplitVC
        vc.productId = detail?.selectedProduct?.id
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
