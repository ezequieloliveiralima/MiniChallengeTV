//
//  CategoriesVC.swift
//  MiniChallengeTV
//
//  Created by Ezequiel de Oliveira Lima on 18/05/16.
//  Copyright © 2016 BEPiD. All rights reserved.
//

import UIKit

class CategoriesVC: UIViewController {
    
    @IBOutlet weak var collectionTop: UICollectionView!
    @IBOutlet weak var collectionAll: UICollectionView!

    var topCategories: List<Category>!
    var allCategories: [String]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MainController.getListTopCategories([]) { (list) in
            self.topCategories = list
        }
        
        MainController.getListCategories([SearchParameter.CategoryId(6420)]) { (list) in
            
        }
    }
    
    
    
}