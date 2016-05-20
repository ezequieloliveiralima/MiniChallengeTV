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
    @IBOutlet weak var btnFavorite: UIButton!
    
    var offersList: [Offer]!
    var product: testProduct!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        offersList = []
        productImage.image = UIImage(data: NSData(contentsOfURL: NSURL(string: product.url)!)!)?.imageByMakingWhiteBackgroundTransparent()
        
        // Do any additional setup after loading the view.
        let productCell = UINib(nibName: "DefaultTableCell", bundle: nil)
        tableView.registerNib(productCell, forCellReuseIdentifier: "product-cell")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if TestLocalStorage.instance.isFavorite(product) {
            btnFavorite.setTitle("Desfavoritar", forState: .Normal)
        }
        
        TestLocalStorage.instance.addHistoric(product)
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
    
    @IBAction func onFavorite(sender: UIButton) {
        if TestLocalStorage.instance.isFavorite(product) {
            TestLocalStorage.instance.removeFavorite(product)
            btnFavorite.setTitle("Favoritar", forState: .Normal)
        } else {
            TestLocalStorage.instance.addFavorite(product)
            btnFavorite.setTitle("Desfavoritar", forState: .Normal)
        }
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

extension ProductVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return offersList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("default-cell") as! GenericTableCell
        
        let offer = offersList[indexPath.row]
        
        cell.label.text = "Ver link da compra"
        cell.imgView.image = UIImage(data: NSData(contentsOfURL: NSURL(string: offer.vendor.thumbnail!.url)!)!)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Fechar", style: .Cancel, handler: nil))
        
        let imageView = UIImageView(frame: CGRect(x: 345, y: -400, width: 400, height: 400))
        alert.view.addSubview(imageView)
        imageView.image = QRCode(content: "http://www.google.com").generate()
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
}