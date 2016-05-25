//
//  FilterResultsVC.swift
//  MiniChallengeTV
//
//  Created by Ezequiel de Oliveira Lima on 19/05/16.
//  Copyright © 2016 BEPiD. All rights reserved.
//

import UIKit

class FilterResultsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pageText : UILabel!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var container: FilterSplitVC?
    var products: List<Product>? {
        didSet {
            results = products?.list
            updateUI()
        }
    }

    var results: [Product]?
    var selectedProduct: Product?
    private var didViewsLoad = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        didViewsLoad = true
        updateUI()
//        tableView.registerNib(UINib(nibName: "DefaultTableCell", bundle: nil), forCellReuseIdentifier: .DefaultCell)
    }
}

extension FilterResultsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(.Product, forIndexPath: indexPath) as! ProductTableCell
        
        guard let product = results?[indexPath.row] else {
            return cell
        }
        
        let price: String
        if let productPrice = product.price {
            switch productPrice {
            case .Value(let v)              : price = "$\(Int(v))"
            case .Discount(let v,_,_)       : price = "$\(Int(v))"
            case .Parcel(let v,_,_,_)       : price = "$\(Int(v))"
            case .Range(let v,_)            : price = "$\(Int(v))"
            }
        } else {
            price = "Sem Ofertas"
        }
        
        cell.nameText.text  = "\(product.nameShort)"
        cell.priceText.text = price
        cell.imgView.image  = nil
        MainConnector.getImage(product.imageUrl) { (img) in
            cell.imgView.image = (img ?? UIImage.defaultImage())//?.imageByMakingWhiteBackgroundTransparent()
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedProduct = products?.list[indexPath.row]
        container?.goToProduct()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150.0
    }
   
}

private extension FilterResultsVC {
    
    @IBAction func selectedPrevButton(sender: UIButton) {
        if let page = products?.detail.page {
            container?.request(page - 1)
        }
    }
    
    @IBAction func selectedNextButton(sender: UIButton) {
        if let page = products?.detail.page {
            container?.request(page + 1)
        }
    }
    
    func updateUI() {
        if !didViewsLoad {
            return
        }
        updateButtons()
        updateTexts()
        tableView.reloadData()
    }
    
    func updateButtons() {
        if let detail = products?.detail {
            prevButton.enabled = detail.page > 1
            nextButton.enabled = detail.page < detail.totalPages
        }
    }
    
    func updateTexts() {
        if let detail = products?.detail {
            pageText.text = "\(detail.page!)/\(detail.totalPages!)"
        }
    }
}

extension FilterResultsVC: FilterDelegate {
    func sort(by sort: SortBy) {
        let f:((Product, Product) -> Bool)
        switch sort {
        case .Alphabetic    : f = { (a:Product, b:Product) -> Bool in a.name < b.name }
        case .DAlphabetic   : f = { (a:Product, b:Product) -> Bool in a.name > b.name }
        case .Rating        : f = { (a:Product, b:Product) -> Bool in Double(a.userRating.value) < Double(b.userRating.value) }
        case .DRating       : f = { (a:Product, b:Product) -> Bool in Double(a.userRating.value) > Double(b.userRating.value) }
        case .Price         : f = { (a:Product, b:Product) -> Bool in
            if let aPrice = a.price, bPrice = b.price {
                switch (aPrice, bPrice) {
                case (.Value(let av), .Value(let bv))                   : return av > bv
                case (.Range(let av, _), .Range(let bv, _))             : return av > bv
                case (.Parcel(let av,_,_,_), .Parcel(let bv,_,_,_))     : return av > bv
                case (.Discount(let av,_,_), .Discount(let bv,_,_))     : return av > bv
                default: return false
                }
            } else {
                return false
            }
        }
        case .DPrice        : f = { (a:Product, b:Product) -> Bool in
            if let aPrice = a.price, bPrice = b.price {
                switch (aPrice, bPrice) {
                case (.Value(let av), .Value(let bv))                   : return av < bv
                case (.Range(_, let av), .Range(_, let bv))             : return av < bv
                case (.Parcel(let av,_,_,_), .Parcel(let bv,_,_,_))     : return av < bv
                case (.Discount(let av,_,_), .Discount(let bv,_,_))     : return av < bv
                default: return false
                }
            } else {
                return false
            }
        }
        }
        results = products?.list.sort(f)
        self.updateUI()
    }
}