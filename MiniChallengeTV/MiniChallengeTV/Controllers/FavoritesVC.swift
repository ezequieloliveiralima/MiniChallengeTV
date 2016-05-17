//
//  FavoritesVC.swift
//  MiniChallengeTV
//
//  Created by Ezequiel de Oliveira Lima on 17/05/16.
//  Copyright © 2016 BEPiD. All rights reserved.
//

import UIKit

class FavoritesVC: UITableViewController {

    var favoritesList: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        favoritesList = []
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        let productCell = UINib(nibName: "ProductTableViewCell", bundle: nil)
        tableView.registerNib(productCell, forCellReuseIdentifier: "product-cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return favoritesList.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("product-cell", forIndexPath: indexPath) as! ProductTableViewCell

        cell.productName.text = favoritesList[indexPath.row]
        let gest = UITapGestureRecognizer(target: self, action: #selector(FavoritesVC.editCell(_:)))
        gest.allowedPressTypes = [ NSNumber(integer: UIPressType.PlayPause.rawValue) ]
        cell.addGestureRecognizer(gest)
        cell.tag = indexPath.row
        // Configure the cell...

        return cell
    }
    
    func editCell(sender: UITapGestureRecognizer) {
        let index = sender.view!.tag

        let alert = UIAlertController(title: "Editar favorito"
            , message: "O que deseja fazer com este item?"
            , preferredStyle: .ActionSheet)

        alert.addAction(UIAlertAction(title: "Remover", style: .Destructive, handler: { (action) -> Void in
            self.favoritesList.removeAtIndex(index)
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
        }))

        alert.addAction(UIAlertAction(title: "Cancelar", style: .Cancel, handler: nil))

        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("", sender: self)
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
