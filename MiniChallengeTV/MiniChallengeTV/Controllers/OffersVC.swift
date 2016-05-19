//
//  OffersVC.swift
//  MiniChallengeTV
//
//  Created by Ezequiel de Oliveira Lima on 17/05/16.
//  Copyright © 2016 BEPiD. All rights reserved.
//

import UIKit

class OffersVC: UIViewController {
    @IBOutlet weak var collectionOffers: UICollectionView!
    @IBOutlet weak var collectionCategories: UICollectionView!
    @IBOutlet weak var offersLoading: UIActivityIndicatorView!
    @IBOutlet weak var categoriesLoading: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageCell = UINib(nibName: "CollectionCellWithImage", bundle: nil)
        let labelCell = UINib(nibName: "CollectionCellWithLabel", bundle: nil)
        collectionOffers.registerNib(imageCell, forCellWithReuseIdentifier: "image-cell")
        collectionCategories.registerNib(labelCell, forCellWithReuseIdentifier: "label-cell")
        
        offersLoading.stopAnimating()
        categoriesLoading.stopAnimating()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.performSegueWithIdentifier("Filter", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
    }

}

extension OffersVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == collectionOffers ? 0 : 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell!
        
        if collectionView == collectionOffers {
            let imageCell = collectionView.dequeueReusableCellWithReuseIdentifier("image-cell", forIndexPath: indexPath) as! CollectionCellWithImage
            cell = imageCell
        } else {
            let labelCell = collectionView.dequeueReusableCellWithReuseIdentifier("label-cell", forIndexPath: indexPath) as! CollectionViewCellWithLabel
            cell = labelCell
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("", sender: self)
    }
}