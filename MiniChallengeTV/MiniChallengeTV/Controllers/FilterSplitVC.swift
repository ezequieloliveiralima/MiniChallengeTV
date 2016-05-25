//
//  FilterSplitVC.swift
//  MiniChallengeTV
//
//  Created by William Cho on 5/23/16.
//  Copyright © 2016 BEPiD. All rights reserved.
//

import UIKit

protocol FilterDelegate {
    func sort(by sort: SortBy)
}

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
                master.container = self
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
    
    func request(page: Int) {
        var params = searchParameters.map({ $0 })
        params.append(.Page(page))
        MainConnector.getListProducts(params, callback: { (products) in
            self.master?.products = products
            self.detail?.products = products
        })
    }
}

extension FilterSplitVC: FilterDelegate {
    func sort(by sort: SortBy) { 
        detail?.sort(by: sort)
    }
}
