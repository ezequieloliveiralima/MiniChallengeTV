//
//  TopProductsVC.swift
//  MiniChallengeTV
//
//  Created by Ezequiel de Oliveira Lima on 19/05/16.
//  Copyright © 2016 BEPiD. All rights reserved.
//

import UIKit


class TopProductsVC: UIViewController {
    
    @IBOutlet weak var collectionTopProducts: UICollectionView!
    @IBOutlet weak var loadingTopProducts: UIActivityIndicatorView!
    
    var selectedProduct: Product?
    var list: List<Product>?
    var searchText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaultCell = UINib(nibName: "DefaultCollectionCell", bundle: nil)
        collectionTopProducts.registerNib(defaultCell, forCellWithReuseIdentifier: "default-cell")
        
        MainConnector.getListTopProducts([]) { (list) in
            self.list = list
            self.collectionTopProducts.reloadData()
            self.loadingTopProducts.stopAnimating()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        if let split = segue.destinationViewController as? UISplitViewController {
            if let split = split as? ProductSplitVC {
                split.product = selectedProduct
            }
            if let split = split as? FilterSplitVC {
                split.searchText = searchText
            }
        }
    }
}

extension TopProductsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list?.list.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let product = list!.list[indexPath.item]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("default-cell", forIndexPath: indexPath) as! GenericCollectionCell
        
        MainConnector.getImage(product.imageUrl, callback: { (image) in
            if let image = image {
                cell.imageView.image = image.imageByMakingWhiteBackgroundTransparent()
            } else {
                cell.imageView.image = UIImage(named: "placeholder")
            }
        })
        
        return cell
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.size.height {
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedProduct = list?.list[indexPath.item]
        self.performSegueWithIdentifier("Select Product", sender: self)
    }
}

extension TopProductsVC: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        searchText = textField.text
        self.performSegueWithIdentifier("Filter", sender: self)
        return true
    }
}