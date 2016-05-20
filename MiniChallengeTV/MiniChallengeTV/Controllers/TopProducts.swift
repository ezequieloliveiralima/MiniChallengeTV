//
//  TopProducts.swift
//  MiniChallengeTV
//
//  Created by Ezequiel de Oliveira Lima on 19/05/16.
//  Copyright © 2016 BEPiD. All rights reserved.
//

import UIKit

typealias testProduct = (id: Int, url: String)

class TopProducts: UIViewController {
    
    @IBOutlet weak var collectionTopProducts: UICollectionView!
    @IBOutlet weak var loadingTopProducts: UIActivityIndicatorView!
    
    var selectedProduct: Product?
    var list: List<Product>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaultCell = UINib(nibName: "DefaultCollectionCell", bundle: nil)
        collectionTopProducts.registerNib(defaultCell, forCellWithReuseIdentifier: "default-cell")
        
        MainController.getListTopProducts([]) { (list) in
            self.list = list
            self.collectionTopProducts.reloadData()
        }
    }
}

extension TopProducts: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list?.list.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let product = list!.list[indexPath.item]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("default-cell", forIndexPath: indexPath) as! GenericCollectionCell
        
        if let thumbnail = product.thumbnails?.maxElement({ $0.0.width > $0.1.width }) {
            cell.imageView.image = UIImage(data: NSData(contentsOfURL: NSURL(string: thumbnail.url)!)!)?.imageByMakingWhiteBackgroundTransparent()
        } else {
            cell.imageView.image = UIImage(named: "placeholder")
        }
        
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        if let split = segue.destinationViewController as? UISplitViewController {
            if let nextVC = (split.viewControllers[1] as? UINavigationController)?.viewControllers[0] as? ProductVC {
                nextVC.product = selectedProduct!
            }
        }
    }
}

