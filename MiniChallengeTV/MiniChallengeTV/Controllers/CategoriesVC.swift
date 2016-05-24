//
//  CategoriesVC.swift
//  MiniChallengeTV
//
//  Created by Ezequiel de Oliveira Lima on 18/05/16.
//  Copyright © 2016 BEPiD. All rights reserved.
//

import UIKit

class CategoriesVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var textSearch: UITextField!

    var topCategories: List<Category>?
    var tempCategories: List<Category>?
    
    private var selectedCategory: Category?
    private var currentList: List<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "DefaultCollectionCell", bundle: nil)
        collectionView.registerNib(nib, forCellWithReuseIdentifier: .DefaultCell)
        collectionView.contentInset = UIEdgeInsets(top: -135, left: 0, bottom: 0, right: 0)
        
        MainConnector.getListTopCategories([]) { (list) in
            self.topCategories = list
            self.updateUI()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        guard let identifier = segue.identifier, segueId = SegueIdentifier(rawValue: identifier) else {
            return
        }
        
        switch (segueId) {
        case .CategorySelected:
            if let split = segue.destinationViewController as? FilterSplitVC {
                split.searchParameters = [SearchParameter.CategoryId(selectedCategory!.id)]
            }
        default: break
        }
    }
}

extension CategoriesVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentList?.list.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(.DefaultCell, forIndexPath: indexPath) as! GenericCollectionCell
        
        guard let category = currentList?.list[indexPath.item] else {
            return cell
        }
        
        cell.label.text = category.name
        MainConnector.getImage(category.imageUrl) { (image) in
            cell.imageView.image = (image ?? UIImage.defaultImage())?.imageByMakingWhiteBackgroundTransparent()
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 250, height: 250)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedCategory = currentList?.list[indexPath.item]
        performSegueWithIdentifier(.CategorySelected, sender: self)
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
    func updateUI() {
        currentList = tempCategories ?? topCategories
        collectionView.reloadData()
    }
    
    func search(keyword text: String?) {
        if text != nil && !text!.isEmpty {
            MainConnector.getListCategories([.Keyword(text!)]) { (list) in
                self.tempCategories = list
                self.updateUI()
            }
        } else {
            tempCategories = nil
            updateUI()
        }
    }
}