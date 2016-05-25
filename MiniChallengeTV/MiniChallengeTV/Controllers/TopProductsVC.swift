//
//  TopProductsVC.swift
//  MiniChallengeTV
//
//  Created by Ezequiel de Oliveira Lima on 19/05/16.
//  Copyright © 2016 BEPiD. All rights reserved.
//

import UIKit


class TopProductsVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loadingTopProducts: UIActivityIndicatorView!
    
    var selectedProduct: Product?
    var list: List<Product>?
    var searchText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaultCell = UINib(nibName: "DefaultCollectionCell", bundle: nil)
        collectionView.registerNib(defaultCell, forCellWithReuseIdentifier: .Default)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 70, bottom: 70, right: 70)
        
        MainConnector.getListTopProducts([]) { (list) in
            self.list = list
            self.collectionView.reloadData()
            self.loadingTopProducts.stopAnimating()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        guard let identifier = segue.identifier, segueId = SegueIdentifier(rawValue: identifier) else {
            return
        }
        
        switch (segueId) {
        case .ProductSearched:
            if let split = segue.destinationViewController as? FilterSplitVC {
                split.searchParameters = [.Keyword(searchText!)]
            }
        case .ProductSelected:
            if let split = segue.destinationViewController as? ProductSplitVC {
                split.productId = selectedProduct?.id
            }
        default: break
        }
    }
}

extension TopProductsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list?.list.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(.Default, forIndexPath: indexPath) as! GenericCollectionCell
        
        guard let product = list?.list[indexPath.item] else {
            return cell
        }
        
        cell.label.text = product.nameShort
        MainConnector.getImage(product.imageUrl, callback: { (img) in
            cell.imageView.image = (img ?? UIImage.defaultImage())//?.imageByMakingWhiteBackgroundTransparent()
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
        self.performSegueWithIdentifier(.ProductSelected, sender: self)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 70
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 70
    }
}

extension TopProductsVC: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        searchText = textField.text
        self.performSegueWithIdentifier(.ProductSearched, sender: self)
        return true
    }
}