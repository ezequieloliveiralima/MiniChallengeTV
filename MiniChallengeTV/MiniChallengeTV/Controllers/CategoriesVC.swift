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
        
        collectionTop.registerNib(UINib(nibName: "DefaultCollectionCell", bundle: nil), forCellWithReuseIdentifier: .DefaultCell)
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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(.DefaultCell, forIndexPath: indexPath) as! GenericCollectionCell
        
//        guard let category = topCategories?.list[indexPath.item] else {
//            return cell
//        }
        
        cell.imageView.image = UIImage(named: "placeholder")
        
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