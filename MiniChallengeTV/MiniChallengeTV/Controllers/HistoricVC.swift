//
//  HistoricVC.swift
//  MiniChallengeTV
//
//  Created by Ezequiel de Oliveira Lima on 19/05/16.
//  Copyright © 2016 BEPiD. All rights reserved.
//

import UIKit

class HistoricVC: UITableViewController {
    
    var historic: [SavedProduct]! = []
    var selectedItem: SavedProduct?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(UINib(nibName: "DefaultTableCell", bundle: nil), forCellReuseIdentifier: "default-cell")
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        MainConnector.getHistory { (list) in
            self.historic = list.reverse()
            self.tableView.reloadData()
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historic!.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("default-cell") as! GenericTableCell
        
        let product = historic[indexPath.row]
        cell.label.text = "\(product.name)"
        if let thumbnail = product.thumbnail {
            ConnectionManager.getImage(thumbnail) { (img) in
                cell.imgView.image = img//?.imageByMakingWhiteBackgroundTransparent()
            }
        } else {
            cell.imgView.image = UIImage.defaultImage()
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedItem = historic![indexPath.row]
        self.performSegueWithIdentifier("Select Product", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        if let split = segue.destinationViewController as? UISplitViewController {
            if let split = split as? ProductSplitVC {
                split.productId = selectedItem?.id
            }
        }
    }
}
