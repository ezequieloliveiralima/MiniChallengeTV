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
    @IBOutlet weak var textSearch: UITextField!

    var topCategories: List<Category>?
    var allCategories: List<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionTop.registerNib(UINib(nibName: "DefaultCollectionCell", bundle: nil), forCellWithReuseIdentifier: "default-cell")
        collectionTop.contentInset = UIEdgeInsets(top: -135, left: 0, bottom: 0, right: 0)
        
        MainConnector.getListTopCategories([]) { (list) in
            self.topCategories = list
            self.collectionTop.reloadData()
        }
    }
    
}

extension CategoriesVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (collectionView.tag == 0 ? topCategories?.list.count : allCategories?.list.count) ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: GenericCollectionCell!
        
        if collectionView.tag == 0 {
            let category = topCategories?.list[indexPath.item]
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("default-cell",
                                                                         forIndexPath: indexPath) as! GenericCollectionCell
            cell.imageView.image = UIImage(named: "placeholder")
        } else {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("category",
                                                                         forIndexPath: indexPath) as! GenericCollectionCell
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 200, height: 200)
    }
}

extension CategoriesVC: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return true
    }
}