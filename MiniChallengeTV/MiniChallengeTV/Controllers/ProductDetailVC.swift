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
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var rating: UIStackView!
    @IBOutlet weak var btnFavorite: UIButton!
    @IBOutlet var imageRating: [UIImageView]!

    private var didViewsLoad = false
    
    var productOffers : ProductOffers? {
        didSet {
            MainConnector.registryHistoric(productOffers!.product)
            updateUI()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        didViewsLoad = true
        tableView.registerNib(UINib(nibName: "DefaultTableCell", bundle: nil), forCellReuseIdentifier: .Default)
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
        let cell = tableView.dequeueReusableCellWithIdentifier(.Default) as! GenericTableCell
        guard let offer = productOffers?.offers[indexPath.row] else {
            return cell
        }
        
        var text = ""
        switch offer.price {
        case .Value(let value):
            text = "$\(String(format: "%.2f", "\(value)"))"
            break
        case .Discount( _, _, let discountPercent):
            text = "\(discountPercent) %"
            break
        case .Parcel(let value, _, _, _):
            text = "$\(value)"
            break
        case .Range(let min, _):
            text = "$\(min)"
            break
        }
        cell.label.text = "\(offer.vendor.name) : \(text)"
        cell.imgView.image = UIImage.defaultImage()
        cell.imgView.backgroundColor = UIColor.whiteColor()

        let url = offer.vendor.thumbnail?.url
        
        MainConnector.getImage(url) { (img) in
            cell.imgView.image = img ?? UIImage.defaultImage()//?.imageByMakingWhiteBackgroundTransparent()
        }
        
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
        if !didViewsLoad {
            return
        }
        MainConnector.getImage(productOffers?.product.imageUrl) { (image) in
            self.productImage.image = image/*?.imageByMakingWhiteBackgroundTransparent()*/ ?? UIImage(named: "placeholder")
            self.productName.text = self.productOffers?.product.nameShort ?? self.productOffers?.product.name
                
                ?? self.productOffers?.product.name
            self.calcalateRating()
        }
        
        MainConnector.isFavorite(productOffers!.product) { (status) in
            self.updateFavoriteButton(status)
        }
        
        tableView.reloadData()
    }
    
    func calcalateRating() {
        let filled = UIImage(named: "star_filled")
        let halfFilled = UIImage(named: "half_star_filled")
        var total = Double(productOffers?.product.userRating.value ?? "0.0") ?? 0.0
        total = total / 2
        let totalInteger = Int(total)
        let rest = total - Double(totalInteger)
        for i in 0..<totalInteger {
            imageRating[i].image = filled
        }
        if rest >= 0.3 {
            imageRating[totalInteger].image = halfFilled
        }
    }
    
    func updateFavoriteButton(status: Bool) {
        btnFavorite.setTitle(status ? "Remover Favorito" : "Adicionar Favorito", forState: .Normal)
        btnFavorite.setImage(status ? UIImage(named: "button-rated")! : UIImage(named: "button-rate")!, forState: .Normal)
    }
}