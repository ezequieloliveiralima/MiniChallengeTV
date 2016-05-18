//
//  ProductVC.swift
//  MiniChallengeTV
//
//  Created by Ezequiel de Oliveira Lima on 18/05/16.
//  Copyright © 2016 BEPiD. All rights reserved.
//

import UIKit

class ProductVC: UIViewController {
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var rating: UIStackView!
    
    var offersList: [String]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        offersList = []

        // Do any additional setup after loading the view.
        let productCell = UINib(nibName: "DefaultTableCell", bundle: nil)
        tableView.registerNib(productCell, forCellReuseIdentifier: "product-cell")
    }
    
    private func calcalateRating(value: Double) {
//        let filled = UIImageView(image: UIImage(named: "star_filled"))
//        let nonFilled = UIImageView(image: UIImage(named: "non_star_filled"))
//        let halfFilled = UIImageView(image: UIImage(named: "half_star_filled"))
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
    
    @IBAction func onBuy(sender: UIButton) {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Fechar", style: .Cancel, handler: nil))
        
        let imageView = UIImageView(frame: CGRect(x: 345, y: -400, width: 400, height: 400))
        alert.view.addSubview(imageView)
        imageView.image = QRCode(content: "http://www.google.com").generate()
        
        self.presentViewController(alert, animated: true, completion: nil)
    }

}

extension ProductVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return offersList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("product-cell") as! DefaultTableCell
        
//        cell.productName =
//        cell.productImage =
        
        return cell
    }
}