//
//  FilterResultsVC.swift
//  MiniChallengeTV
//
//  Created by Ezequiel de Oliveira Lima on 19/05/16.
//  Copyright © 2016 BEPiD. All rights reserved.
//

import UIKit

class FilterResultsVC: UITableViewController {
    
    var container: FilterSplitVC?
    var products: List<Product>? {
        didSet {
            updateUI()
        }
    }

    var selectedProduct: Product?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerNib(UINib(nibName: "DefaultTableCell", bundle: nil), forCellReuseIdentifier: .DefaultCell)
    }
}

extension FilterResultsVC {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products?.list.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(.DefaultCell, forIndexPath: indexPath) as! GenericTableCell
        
        guard let product = products?.list[indexPath.row] else {
            return cell
        }
        
        cell.label.text = "\(product.name)"
        cell.imgView.image = UIImage.defaultImage()
        MainConnector.getImage(product.imageUrl) { (img) in
            cell.imgView.image = (img ?? UIImage.defaultImage())?.imageByMakingWhiteBackgroundTransparent()
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedProduct = products?.list[indexPath.row]
        container?.goToProduct()
    }
}

private extension FilterResultsVC {
    
    func updateUI() {
        tableView.reloadData()
    }
    
}