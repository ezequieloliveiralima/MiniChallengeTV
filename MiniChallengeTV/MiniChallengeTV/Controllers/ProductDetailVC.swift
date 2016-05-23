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
            MainConnector.registryHistoric(productOffers!.product)
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
        let product = productOffers!.product
        MainConnector.isFavorite(product) { (status) in
            var status1: Bool!

            if status {
                status1 = false
                MainConnector.removeFavorite(product.id, callback: nil)
            } else {
                status1 = true
                MainConnector.addFavorite(product, callback: nil)
            }
            
            self.updateFavoriteButton(status1)
        }
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
        let imageVendor = "http://imagem.buscape.com.br/vitrine/logo\(offer.vendor.id).gif"
        MainConnector.getImage(imageVendor, callback: { (img) in
            cell.imgView.image = img ?? UIImage(named: "placeholder")?.imageByMakingWhiteBackgroundTransparent()
        })
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Fechar", style: .Cancel, handler: nil))
        
        let imageView = UIImageView(frame: CGRect(x: 345, y: -400, width: 400, height: 400))
        alert.view.addSubview(imageView)
        let offer = productOffers?.offers[indexPath.row]
        imageView.image = QRCode(content: offer?.url ?? "").generate()
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

//Private
private extension ProductDetailVC {
    func updateUI() {
        MainConnector.getImage(productOffers?.product.imageUrl) { (image) in
            self.productImage.image = image?.imageByMakingWhiteBackgroundTransparent() ?? UIImage(named: "placeholder")
            self.productName.text = self.productOffers?.product.nameShort
        }
        
        MainConnector.isFavorite(productOffers!.product) { (status) in
            self.updateFavoriteButton(status)
        }
        
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