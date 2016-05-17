//
//  BuscapeConnector.swift
//  BuscapeAPI
//
//  Created by William Cho on 5/12/16.
//  Copyright © 2016 wc. All rights reserved.
//

import Foundation

typealias Payload = [String : AnyObject]

class BuscapeConnector {
    
    static let cacheURL = NSURLCache(memoryCapacity: 20 * 1024 * 1024, diskCapacity: 100 * 1024 * 1024, diskPath: "ImageDownloadCache")
    static let session: NSURLSession = {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        config.requestCachePolicy = NSURLRequestCachePolicy.ReturnCacheDataElseLoad
        config.URLCache = cacheURL
        return NSURLSession(configuration: config)
    }()
    
    func openConnection(uri: String, completionHandler:((Payload?, NSURLResponse?, NSError?) -> Void)) {
        print(uri)
        guard let url = NSURL(string: uri) else {
            return
        }
        let request = NSURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 30.0)
        BuscapeConnector.session.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
            do {
                //print(NSString(data: data!, encoding: NSUTF8StringEncoding), "\n\n")
                var json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? Payload
                json = self.changeKeyToLower(&json!)
//                print(json)
                completionHandler(json, response, error)
            } catch _ {
                print("JSON Serialization Error")
            }
        }).resume()
    }
    
    private func changeKeyToLower(inout payload: Payload) -> Payload {
        for (key, value) in payload {
            if let v = value as? [Payload] {
                payload[key] = v.map({ (vv) -> Payload in
                    var mutableVV = vv
                    return changeKeyToLower(&mutableVV)
                })
            }
            if var v = value as? Payload {
                payload[key] = changeKeyToLower(&v)
            }
            let temp = payload[key]
            payload.removeValueForKey(key)
            payload[key.lowercaseString] = temp
        }
        return payload
    }

    func getTopProducts(callback: (BTopProducts) -> Void) {
        getTopProducts(1, callback: callback)
    }
    
    func getTopProducts(page: Int, callback: (BTopProducts) -> Void) {
        let uri = BuscapeAPI(type: BuscapeSearchType.TopProducts)
            .setParameter("page", value: String(page))
            .getURI()
        openConnection(uri) { (json, response, error) in
            guard let json = json, products = json["product"] as? [Payload] else {
                print("TODO error getting Top Products")
                return
            }
            let top = BTopProducts()
            top.detail = self.parseListDetail(json)
            top.products = products.map({ self.parseProduct($0) })
            callback(top)
        }
    }
    
    func getTopCategories(callback: (BTopCategories) -> Void) {
        getTopCategories(1, callback: callback)
    }
    
    func getTopCategories(page:Int, callback: (BTopCategories) -> Void) {
        let uri = BuscapeAPI(type: BuscapeSearchType.TopCategories).getURI()
        openConnection(uri) { (json, response, error) in
            guard let json = json, categories = json["subcategory"] as? [Payload] else {
                print("TODO error getting Top Categories")
                return
            }
            
            let top = BTopCategories()
            top.detail = self.parseListDetail(json)
            top.categories = categories.map({ self.parseCategory($0) })
            callback(top)
        }
    }
    
    func getTopOffers(callback: (BTopOffers) -> Void) {
        getTopOffers(1, callback: callback)
    }
    
    func getTopOffers(page:Int, callback: (BTopOffers) -> Void) {
        let uri = BuscapeAPI(type: BuscapeSearchType.TopOffers).getURI()
        openConnection(uri) { (json, response, error) in
            guard let json = json, offers = json["offer"] as? [Payload] else {
                print("TODO error getting Top Offers")
                return
            }
            let top = BTopOffers()
            top.detail = self.parseListDetail(json)
            top.offers = offers.map({ self.parseOffer($0) })
            callback(top)
        }
    }
    
    func getProduct(id: Int, callback: (BFindProduct) -> Void) {
        let uri = BuscapeAPI(type: BuscapeSearchType.Product(id: id)).getURI()
        openConnection(uri) { (json, response, error) in
            guard let json = json, offers = json["offer"] as? [Payload], product = json["product"]?[0]?["product"] as? Payload
                , category = json["category"] as? Payload else {
                print("TODO error getting Product by Id")
                return
            }
            
            let find = BFindProduct()
            find.detail = self.parseListDetail(json)
            find.offers = offers.map({ self.parseOffer($0["offer"] as! Payload) })
            find.product = self.parseProduct(product)
            find.category = self.parseCategory(category)
            callback(find)
        }
    }
    
    
}

private extension BuscapeConnector {
    func parseListDetail(json: Payload) -> BListDetail {
        var detail = BListDetail()
        detail.page                    = json["page"] as! Int
        detail.totalPages              = json["totalpages"] as! Int
        detail.totalResultsReturned    = json["totalresultsreturned"] as! Int
        detail.totalResultsAvailable   = json["totalresultsavailable"] as! Int
        return detail
    }
    
    func parseCategory(json: Payload) -> BCategory {
        let category = BCategory(id: json["id"] as! Int)
        category.idParent   = json["parentcategoryid"] as! Int
        category.name       = json["name"] as! String
        category.isFinal    = json["isfinal"] as! Bool
        category.hasOffer   = json["hasoffer"] as! Bool
        category.hasProduct = json["hasproduct"] as? Bool ?? false
        
        if let thumbnail = json["thumbnail"] as? Payload {
            category.thumbnailUrl = thumbnail["url"] as? String
        }
        if let links = json["links"]?["link"] as? [Payload] {
            links.forEach({ (link) in
                switch link["type"] as! String {
                case "list_product": category.productsUrl = link["url"] as! String
                case "list_offer": category.offersUrl = link["url"] as! String
                default: break
                }
            })
        }
        return category
    }
    
    func parseProduct(json: Payload) -> BProduct {
        let product = BProduct(id: json["id"] as! Int)
        product.name        = json["productname"] as! String
        product.nameShort   = json["productshortname"] as! String
        product.price       = Price.Range(min: Double(json["pricemin"] as! String)!, max: Double(json["pricemax"] as! String)!)
        //fulldescription
        //hasmetasearch
        //eco
        //numoffers
        //totalsellers
        
        if let links = json["links"]?["link"] as? [Payload] {
            links.forEach({ (link) in
                switch link["type"] as! String {
                case "product":
                    product.url = link["url"] as! String
                case "xml":
                    product.detailUrl = link["url"] as! String
                default: break
                }
            })
        }
        
        if let thumbnail = json["thumbnail"] as? Payload {
            product.thumbnailUrl = thumbnail["url"] as? String
            if let formats = thumbnail["formats"] as? [Payload] {
                formats.forEach({ (format) in
                    var format = format
                    if format.contains({ $0.0 == "formats" }) {
                        format = format["formats"] as! Payload
                    }
                    
                    switch format["width"] as! Int {
                    case 600: product.imageUrl = format["format"]?["url"] as? String
                    default: break
                    }
                })
            }
        }
        
        if let rating = json["rating"] as? Payload {
            if let user = rating["useraveragerating"] as? Payload {
                product.userRating = Rating(value: user["rating"] as! String
                    , numComments: user["numcomments"] as! Int
                    , url: (user["links"] as? [Payload])?[0]["url"] as? String)
            }
        }
        
        if let specification = json["specification"] as? Payload {
            var spec = Specification()
            if let links = specification["links"]?["link"] as? [Payload] {
                spec.url = links[0]["url"] as? String
            }
            if let items = specification["items"] as? [Payload] {
                spec.items = items.map({ (item) -> (String, [String]) in
                    let label = item["label"] as! String
                    let value = item["value"] as! [String]
                    return (label, value)
                })
            }
        }
        
        return product
    }
    
    func parseOffer(json: Payload) -> BOffer {
        let offer = BOffer(id: json["id"] as! Int)
        offer.idProduct     = json["productid"] as! Int
        offer.idCategory    = json["categoryid"] as! Int
        offer.name          = json["offername"] as! String
        
        offer.thumbnailUrl  = json["thumbnail"]?["url"] as? String
        
        if let price = json["price"] as? Payload, parcel = price["parcel"] as? Payload {
            offer.price = Price.Parcel(value: Double(price["value"] as! String)!
                , parcelValue: Double(parcel["value"] as! String)!
                , interest: Double(parcel["interest"] as! Int)
                , parcel: parcel["number"] as! Int)
        } else if let value = json["pricevalue"] as? String, fromValue = json["pricefromvalue"] as? String, discount = json["discountpercent"] as? String {
            offer.price = Price.Discount(value: Double(value)!
                , originalValue: Double(fromValue)!
                , discountPercent: Double(discount)!)
        }
        
        if let links = json["links"]?["link"] as? [Payload] {
            links.forEach({ (json) in
                switch json["type"] as! String {
                case "offer":
                    offer.url = json["url"] as! String
                    break
                default: break
                }
            })
        }
        
        if let seller = json["seller"] as? Payload {
            offer.vendor = parseVendor(seller)
        }
        
        return offer
    }
    
    func parseVendor(json: Payload) -> BVendor {
        let vendor = BVendor(id: json["id"] as! Int)
        vendor.name = json["sellername"] as! String
        vendor.thumbnailUrl = json["thumbnail"]?["url"] as? String
        
        if let links = json["links"] as? [Payload] {
            links.forEach({ (json) in
                let link = json["link"] as! Payload
                switch link["type"] as! String {
                case "seller": vendor.url = link["url"] as! String
                default: break
                }
            })
        }
        
        if let contacts = json["contacts"] as? [Payload] {
            vendor.contacts = contacts.map({ (json) -> (String, String) in
                let contact = json["contact"] as! Payload
                return (contact["label"] as! String, contact["value"] as! String)
            })
        }
        
        return vendor
    }
    
    func parseRating(json: Payload) -> Rating? {
        if let user = json["useraveragerating"] as? Payload {
            var url: String?
            if let links = user["links"]?["link"] as? [Payload] {
                links.forEach({ (link) in
                    switch link["type"] as! String {
                    case "xml": url = link["url"] as? String
                    default: break
                    }
                })
            }
            return Rating(value: user["rating"] as! String, numComments: user["numcomments"] as! Int, url: url)
        }
        return nil
    }
}