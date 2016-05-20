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

        MainController.getListTopCategories(SearchParameter.Page(1)) { (list) in
            dispatch_async(dispatch_get_main_queue(), { 
                self.topCategories = list
                self.collectionTop.reloadData()
            })
        }
        
        let defaultCell = UINib(nibName: "DefaultCollectionCell", bundle: nil)
        collectionTop.registerNib(defaultCell, forCellWithReuseIdentifier: "default-cell")
        // Do any additional setup after loading the view.
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
}

extension CategoriesVC: UICollectionViewDelegate, UICollectionViewDataSource {
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
}

extension CategoriesVC: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return true
    }
}