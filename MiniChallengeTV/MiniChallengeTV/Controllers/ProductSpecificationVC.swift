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
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return productOffers?.product.specification?.items?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return productOffers?.product.specification?.items?[section].name
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productOffers?.product.specification?.items?[section].value.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(.Specification)!
        
        guard let specification = productOffers?.product.specification?.items?[indexPath.section].value[indexPath.row] else {
            return cell
        }
        
        cell.textLabel?.text = "\(specification)"
        
        return cell
    }
}

private extension ProductSpecificationVC {
    
    func updateUI() {
        tableView.reloadData()
    }
    
}
