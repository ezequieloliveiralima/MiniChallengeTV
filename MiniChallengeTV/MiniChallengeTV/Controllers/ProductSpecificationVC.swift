//
//  SpecificationsVC.swift
//  MiniChallengeTV
//
//  Created by Ezequiel de Oliveira Lima on 19/05/16.
//  Copyright © 2016 BEPiD. All rights reserved.
//

import UIKit

class ProductSpecificationVC: UITableViewController {
    
    var productOffers: ProductOffers? {
        didSet {
            updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerNib(UINib(nibName: "DefaultTableCell", bundle: nil), forCellReuseIdentifier: "default-cell")
        
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productOffers?.product.specification?.items?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("default-cell") as! GenericTableCell
        
        guard let specification = productOffers?.product.specification?.items?[indexPath.row] else {
            return cell
        }
        
        cell.label.text = "\(specification.name): \(specification.value)"
        
        return cell
    }
}

private extension ProductSpecificationVC {
    
    func updateUI() {
        print(productOffers?.product.specification)
        tableView.reloadData()
    }
    
}
