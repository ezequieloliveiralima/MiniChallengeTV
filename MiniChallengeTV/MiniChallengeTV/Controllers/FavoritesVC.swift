//
//  FavoritesVC.swift
//  MiniChallengeTV
//
//  Created by Ezequiel de Oliveira Lima on 17/05/16.
//  Copyright © 2016 BEPiD. All rights reserved.
//

import UIKit

class FavoritesVC: UITableViewController {

    var favoritesList: [SavedProduct]! = []
    var selectedProduct: SavedProduct?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let productCell = UINib(nibName: "DefaultTableCell", bundle: nil)
        tableView.registerNib(productCell, forCellReuseIdentifier: .DefaultCell)
        
//        favoritesList = TestLocalStorage.instance.favorits
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        MainConnector.getFavorites { (list) in
            self.favoritesList = list
            self.tableView.reloadData()
        }
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return favoritesList.count ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(.DefaultCell, forIndexPath: indexPath) as! GenericTableCell

        let product = favoritesList[indexPath.row]
        cell.label.text = "\(product.name)"
        ConnectionManager.getImage(product.thumbnail) { (img) in
            cell.imgView.image = (img ?? UIImage.defaultImage())?.imageByMakingWhiteBackgroundTransparent()
        }
        
        let gest = UITapGestureRecognizer(target: self, action: #selector(FavoritesVC.editCell(_:)))
        gest.allowedPressTypes = [ NSNumber(integer: UIPressType.PlayPause.rawValue) ]
        cell.addGestureRecognizer(gest)
        cell.tag = indexPath.row
        // Configure the cell...

        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        if let split = segue.destinationViewController as? UISplitViewController {
            if let split = split as? ProductSplitVC {
                split.productId = selectedProduct?.id
            }
        }
    }
    
    func editCell(sender: UITapGestureRecognizer) {
        let index = sender.view!.tag

        let alert = UIAlertController(title: "Opções de favorito"
            , message: "O que deseja fazer com este item?"
            , preferredStyle: .ActionSheet)

        alert.addAction(UIAlertAction(title: "Remover", style: .Destructive, handler: { (action) -> Void in
            MainConnector.removeFavorite(self.favoritesList[index].id, callback: nil)
            self.favoritesList.removeAtIndex(index)
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
        }))

        alert.addAction(UIAlertAction(title: "Cancelar", style: .Cancel, handler: nil))

        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedProduct = favoritesList![indexPath.row]
        self.performSegueWithIdentifier("Select Product", sender: self)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150.0
    }

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
