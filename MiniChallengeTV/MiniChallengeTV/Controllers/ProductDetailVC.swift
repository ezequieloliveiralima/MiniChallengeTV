//
//  ProductVC.swift
//  MiniChallengeTV
//
//  Created by Ezequiel de Oliveira Lima on 18/05/16.
//  Copyright © 2016 BEPiD. All rights reserved.
//

import UIKit

class ProductDetailVC: UIViewController {
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var rating: UIStackView!
    @IBOutlet weak var btnFavorite: UIButton!
    
    var productOffers : ProductOffers? {
        didSet {
            updateUI()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(UINib(nibName: "DefaultTableCell", bundle: nil), forCellReuseIdentifier: "default-cell")
    }

}

//Actions
extension ProductDetailVC {
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
extension ProductDetailVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productOffers?.offers.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("default-cell") as! GenericTableCell
        guard let offer = productOffers?.offers[indexPath.row] else {
            return cell
        }
        
        cell.label.text = offer.vendor.name
        cell.imgView.image = UIImage.defaultImage()
        MainConnector.getImage(offer.vendor.thumbnail?.url, callback: { (img) in
            if let img = img {
                cell.imgView.image = img
            }
        })
        
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
private extension ProductDetailVC {
    func updateUI() {
        MainConnector.getImage(productOffers?.product.imageUrl) { (image) in
            self.productImage.image = image?.imageByMakingWhiteBackgroundTransparent() ?? UIImage(named: "placeholder")
        }
        updateFavoriteButton(true)
        tableView.reloadData()
    }
    
    func calcalateRating(value: Double) {
//        let filled = UIImageView(image: UIImage(named: "star_filled"))
//        let nonFilled = UIImageView(image: UIImage(named: "non_star_filled"))
//        let halfFilled = UIImageView(image: UIImage(named: "half_star_filled"))
    }
    
    func updateFavoriteButton(status: Bool) {
        btnFavorite.setTitle(status ? "Remover Favorito" : "Adicionar Favorito", forState: .Normal)
    }
}