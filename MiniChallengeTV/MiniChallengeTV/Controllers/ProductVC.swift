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
    
    var offers  : List<Offer>?
    var product : Product!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(UINib(nibName: "DefaultTableCell", bundle: nil), forCellReuseIdentifier: "default-cell")

        if let imageUrl = product.imageUrl {
            productImage.image = UIImage(data: NSData(contentsOfURL: NSURL(string: imageUrl)!)!)?.imageByMakingWhiteBackgroundTransparent()
        } else {
            productImage.image = UIImage(named: "placeholder")
        }
        
        MainConnector.getProductOffers(product, params: []) { (list) in
            self.offers = list
            self.tableView.reloadData()
        }
        
        updateFavoriteButton(true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
//        if TestLocalStorage.instance.isFavorite(product) {
//            btnFavorite.setTitle("Desfavoritar", forState: .Normal)
//        }
//        
//        TestLocalStorage.instance.addHistoric(product)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//Actions
extension ProductVC {
    @IBAction func onFavorite(sender: UIButton) {
//        if TestLocalStorage.instance.isFavorite(product) {
//            TestLocalStorage.instance.removeFavorite(product)
//            btnFavorite.setTitle("Favoritar", forState: .Normal)
//        } else {
//            TestLocalStorage.instance.addFavorite(product)
//            btnFavorite.setTitle("Desfavoritar", forState: .Normal)
//        }
    }
}

//Delegate
extension ProductVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return offers?.list.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("default-cell") as! GenericTableCell
        let offer = offers!.list[indexPath.row]
        
        cell.label.text = offer.vendor.name
        if let imageUrl = offer.vendor.thumbnail?.url {
            MainConnector.getImage(imageUrl, callback: { (img) in
                cell.imgView.image = img
            })
        } else {
            cell.imgView.image = UIImage(named: "placeholder")
        }
        
        
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

//Private
private extension ProductVC {
    func calcalateRating(value: Double) {
//        let filled = UIImageView(image: UIImage(named: "star_filled"))
//        let nonFilled = UIImageView(image: UIImage(named: "non_star_filled"))
//        let halfFilled = UIImageView(image: UIImage(named: "half_star_filled"))
    }
    
    func updateFavoriteButton(status: Bool) {
        btnFavorite.setTitle(status ? "Remover Favorito" : "Adicionar Favorito", forState: .Normal)
    }
}