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
        
        getTopCategories()
    }
    
}

extension CategoriesVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case collectionTop:
            return topCategories?.list.count ?? 0
        case collectionAll:
            return allCategories?.list.count ?? 0
        default:
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(.DefaultCell, forIndexPath: indexPath) as! GenericCollectionCell
        let list: List<Category>?
        switch collectionView {
        case collectionTop:
            list = topCategories
        case collectionAll:
            list = allCategories
        default:
            list = nil
        }
        
        guard let category = list?.list[indexPath.item] else {
            return cell
        }
        
//        cell.label.text = category.name
        MainConnector.getImage(category.imageUrl) { (image) in
            cell.imageView.image = (image) ?? UIImage.defaultImage()
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
    
    func textFieldDidEndEditing(textField: UITextField) {
        search(keyword: textField.text)
    }
}

private extension CategoriesVC {
    func updateTopUI(list list: List<Category>?) {
        topCategories = list
        collectionTop.reloadData()
    }
    
    func updateBottomUI(list list: List<Category>?) {
        allCategories = list
        collectionAll.reloadData()
    }
    
    func getTopCategories() {
        MainConnector.getListTopCategories([]) { (list) in
            self.updateTopUI(list: list)
        }
    }
    
    func search(keyword text: String?) {
        if let keyword = text {
            MainConnector.getListCategories([.Keyword(keyword)]) { (list) in
                self.updateBottomUI(list: list)
            }
        } else {
            updateBottomUI(list: nil)
        }
        
    }
}