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
    
    var topList: [testProduct]! = []
    var selectedProduct: testProduct?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaultCell = UINib(nibName: "DefaultCollectionCell", bundle: nil)
        collectionTopProducts.registerNib(defaultCell, forCellWithReuseIdentifier: "default-cell")

        let image = "https://vocedeapple.com/52-thickbox_default/iphone-4s-barato.jpg"
        dispatch_after(0, dispatch_get_main_queue()) {
            self.topList.append((id: 1, url: image))
            self.topList.append((id: 2, url: image))
            self.topList.append((id: 3, url: image))
            self.topList.append((id: 4, url: image))
            self.topList.append((id: 5, url: image))
            self.topList.append((id: 6, url: image))
            self.collectionTopProducts.reloadData()
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
        cell.imageView.image = UIImage(data: NSData(contentsOfURL: NSURL(string: product.url)!)!)?.imageByMakingWhiteBackgroundTransparent()
        return cell
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.size.height {
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedProduct = topList[indexPath.row]
        self.performSegueWithIdentifier("Select Product", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        if let split = segue.destinationViewController as? UISplitViewController {
            if let nextVC = (split.viewControllers[1] as? UINavigationController)?.viewControllers[0] as? ProductVC {
                nextVC.product = selectedProduct
            }
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