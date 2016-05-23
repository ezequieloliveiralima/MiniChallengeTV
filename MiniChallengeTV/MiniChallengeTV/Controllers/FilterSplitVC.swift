//
//  FilterSplitVC.swift
//  MiniChallengeTV
//
//  Created by William Cho on 5/23/16.
//  Copyright © 2016 BEPiD. All rights reserved.
//

import UIKit

class FilterSplitVC: UISplitViewController {
    
    var searchText: String! {
        didSet {
            MainConnector.getListProducts([.Keyword(searchText)]) { (list) in
                let vc = self.viewControllers
                //let master = (vc[0] as! UINavigationController).viewControllers.first as! FilterOptionsVC
                let detail = (vc[1] as! UINavigationController).viewControllers.first as! FilterResultsVC
                
                detail.products = list
            }
        }
    }
    
    
}