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
    var results: [Product]? = []
    var products: List<Product>? {
        didSet {
            print(products)
            results = products?.list
            updateUI()
        }
    }

    var selectedProduct: Product?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerNib(UINib(nibName: "DefaultTableCell", bundle: nil), forCellReuseIdentifier: .DefaultCell)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(.DefaultCell, forIndexPath: indexPath) as! GenericTableCell
        
        guard let product = results?[indexPath.row] else {
            return cell
        }
        
        cell.label.text = "\(product.nameShort)"
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150.0
    }
    
}

private extension FilterResultsVC {
    
    func updateUI() {
        tableView.reloadData()
    }
    
}

extension FilterResultsVC: FilterDelegate {
    func filter(by filter: FilterType) {
        results = products?.list.sort({ (f, s) -> Bool in
            switch filter {
            case .Alphabetic: return f.name < s.name
            case .BetterRated: return Double(f.userRating.value) < Double(s.userRating.value)
            case .BiggestPrice: return f.name < s.name
            case .LowestPrice: return f.name < s.name
            }
        })
        self.updateUI()
    }
}