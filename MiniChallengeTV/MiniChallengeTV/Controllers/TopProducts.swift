//
//  TopProducts.swift
//  MiniChallengeTV
//
//  Created by Ezequiel de Oliveira Lima on 19/05/16.
//  Copyright © 2016 BEPiD. All rights reserved.
//

import UIKit

class TopProducts: UIViewController {
    @IBOutlet weak var collectionTopProducts: UICollectionView!
    @IBOutlet weak var loadingTopProducts: UIActivityIndicatorView!
    
    var topList: [BProduct]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaultCell = UINib(nibName: "DefaultCollectionCell", bundle: nil)
        collectionTopProducts.registerNib(defaultCell, forCellWithReuseIdentifier: "default-cell")
        
        BuscapeConnector().getTopProducts { (list) in
            self.topList = list.list
            dispatch_async(dispatch_get_main_queue(), {
                self.collectionTopProducts.reloadData()
                self.loadingTopProducts.stopAnimating()
            })
        }
    }
}

extension TopProducts: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topList.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let product = topList[indexPath.row]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("default-cell", forIndexPath: indexPath) as! GenericCollectionCell
        cell.imageView.image = UIImage(data: NSData(contentsOfURL: NSURL(string: product.thumbnails![0].url)!)!)?.imageByMakingWhiteBackgroundTransparent()
        return cell
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.size.height {
        }
    }
}

extension UIImage {
    func imageByMakingWhiteBackgroundTransparent() -> UIImage? {
        if let rawImageRef = self.CGImage {
            let colorMasking: [CGFloat] = [200, 255, 200, 255, 200, 255]
            UIGraphicsBeginImageContext(self.size)
            if let maskedImageRef = CGImageCreateWithMaskingColors(rawImageRef, colorMasking) {
                CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0.0, self.size.height)
                CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1.0, -1.0)
                CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, self.size.width, self.size.height), maskedImageRef)
                let result = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                return result
            }
        }
        return nil
    }
}