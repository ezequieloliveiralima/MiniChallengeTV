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

    func getTopProducts(callback: (BList<BProduct>) -> Void) {
        let uri = BuscapeAPI(searchType: .TopProducts).addParameters(.Format(.JSON)).getURI()
            openConnection(uri) { (json, response, error) in
                guard let json = json, products = json["product"] as? [Payload] else {
                    print("TODO error getting Top Products")
                    return
                }
                
                let detail = self.parseListDetail(json)!
                let list = products.flatMap({ self.parseProduct($0) })
                let top = BList<BProduct>(detail: detail, list: list)
                callback(top)
        }
    }
    
    
    func getTopCategories(callback: (BList<BCategory>) -> Void) {
        let uri = BuscapeAPI(searchType: .TopCategories).addParameters(.Format(.JSON)).getURI()
        openConnection(uri) { (json, response, error) in
            guard let json = json, categories = json["subcategory"] as? [Payload] else {
                print("TODO error getting Top Categories")
                return
            }
            
            let detail = self.parseListDetail(json)!
            let list = categories.flatMap({ self.parseCategory($0) })
            let top = BList<BCategory>(detail: detail, list: list)
            callback(top)
        }
    }
    
    func getTopOffers(callback: (BList<BOffer>) -> Void) {
        let uri = BuscapeAPI(searchType: .TopOffers).addParameters(.Format(.JSON)).getURI()
        openConnection(uri) { (json, response, error) in
            guard let json = json, offers = json["offer"] as? [Payload] else {
                print("TODO error getting Top Offers")
                return
            }
            let detail = self.parseListDetail(json)!
            let list = offers.flatMap({ self.parseOffer($0) })
            let top = BList<BOffer>(detail: detail, list: list)
            callback(top)
        }
    }
    
    func getProductOffers(id: Int, callback: (BProductOffers) -> Void) {
        let uri = BuscapeAPI(searchType: .Offer).addParameters(.Format(.JSON), .ProductId(id)).getURI()
        openConnection(uri) { (json, response, error) in
            guard let json = json, offersJson = json["offer"] as? [Payload], productJson = json["product"]?[0]?["product"] as? Payload
                , categoryJson = json["category"] as? Payload else {
                    print("TODO error getting Product by Id")
                    return
            }
            
            let detail = self.parseListDetail(json)!
            let product = self.parseProduct(productJson)!
            let category = self.parseCategory(categoryJson)!
            let offers = offersJson.flatMap({ self.parseOffer($0) })
            let result = BProductOffers(detail: detail, product: product, category: category, offers: offers)
            callback(result)
        }
    }
    
    func find(product: Int, callback: (BList<BProduct>) -> Void) {
        
    }
}

private extension BuscapeConnector {
    
    func changeKeyToLower(inout payload: Payload) -> Payload {
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
    
    func parseListDetail(json: Payload) -> BListDetail? {
        guard let page = json["page"] as? Int
            , totalPages = json["totalpages"] as? Int
            , totalResultsReturned = json["totalresultsreturned"] as? Int
            , totalResultsAvailable = json["totalresultsavailable"] as? Int else {
                return nil
        }
        return BListDetail(page: page, totalPages: totalPages, totalResultsReturned: totalResultsReturned, totalResultsAvailable: totalResultsAvailable)
    }
    
    func parseCategory(json: Payload) -> BCategory? {
        guard let id        = json["id"] as? Int
            , idParent      = json["parentcategoryid"] as? Int
            , name          = json["name"] as? String
            , isFinal       = json["isfinal"] as? Bool
            , links         = parseLinks(json)
            else {
            print("Category didn't parse properly")
            return nil
        }
        
        let thumbnail = parseThumbnail(json)
        let productUrl    = links.filter({ $0.0 == "list_product" }).first?.0
        let offerUrl      = links.filter({ $0.0 == "list_offer" }).first?.0
        return BCategory(id: id, idParent: idParent, name: name, isFinal: isFinal, productsUrl: productUrl, offersUrl: offerUrl, thumbnail: thumbnail)
    }
    
    func parseProduct(json: Payload) -> BProduct? {
        let json = nestedValue(json, key: "product")
        guard let id        = json["id"] as? Int
            , idCategory    = json["categoryid"] as? Int
            , name          = json["productname"] as? String
            , nameShort     = json["productshortname"] as? String
            , price         = parsePrice(json)
            , links         = parseLinks(json)
            , url           = links.filter({ $0.0 == "product"}).first?.1
            , detailUrl     = links.filter({ $0.0 == "xml" }).first?.1
            , rating        = parseRating(json) else {
            //fulldescription
            //hasmetasearch
            //eco
            //numoffers
            //totalsellers
            print("Product didn't parse properly")
            return nil
        }
        
        let thumbnails = parseThumbnails(json)
        let specification = parseSpecification(json)
        
        return BProduct(id: id, idCategory: idCategory, name: name, nameShort: nameShort, price: price, rating: rating, url: url, detail: detailUrl, thumbnails: thumbnails, specification: specification)
    }
    
    func parseOffer(json: Payload) -> BOffer? {
        let json = nestedValue(json, key: "offer")
        guard let id        = json["id"] as? Int
            , idProduct     = json["productid"] as? Int
            , idCategory    = json["categoryid"] as? Int
            , name          = json["offername"] as? String
            , price         = parsePrice(json)
            , links         = parseLinks(json)
            , url           = links.filter({ $0.0 == "offer" }).first?.1
            , vendor        = parseVendor(json)
            else {
            print("Offer didn't parse properly")
            return nil
        }
        
        let thumbnail = parseThumbnail(json)
        
        return BOffer(id: id, idCategory: idCategory, idProduct: idProduct, name: name, price: price, url: url, thumbnail: thumbnail, vendor: vendor)
    }
    
    func parseVendor(json: Payload) -> BVendor? {
        guard let vendor    = json["seller"] as? Payload
            , id            = vendor["id"] as? Int
            , name          = vendor["sellername"] as? String
            , rating        = parseRating(vendor)
            else {
            print("Vendor didn't parse properly")
            return nil
        }
        
        let thumbnail   = parseThumbnail(vendor)
        let links       = parseLinks(vendor)
        let url         = links?.filter({ $0.0 == "seller" }).first?.1
        
        return BVendor(id: id, name: name, rating: rating, url: url, thumbnail: thumbnail)
    }
    
    func parsePrice(json: Payload) -> Price? {
        if let minStr = json["pricemin"] as? String, maxStr = json["pricemax"] as? String {
            if let  min = Double(minStr), max = Double(maxStr) {
                return Price.Range(min: min, max: max)
            }
        } else if let value = json["pricevalue"] as? NSNumber, fromValue = json["pricefromvalue"] as? NSNumber, discount = json["discountpercent"] as? NSNumber {
            return Price.Discount(value: value.doubleValue, originalValue: fromValue.doubleValue, discountPercent: discount.doubleValue)
        } else if let price = json["price"] as? Payload {
            if let parcel = price["parcel"] as? Payload
                , valueStr = price["value"] as? String, parcelValueStr = parcel["value"] as? String, interest = parcel["interest"] as? Int, parcelNum = parcel["number"] as? Int {
                if let value = Double(valueStr), parcelValue = Double(parcelValueStr) {
                    return Price.Parcel(value: value, parcelValue: parcelValue, interest: Double(interest), parcel: parcelNum)
                }
            } else if let valueStr = price["value"] as? String, value = Double(valueStr) {
                return Price.Value(value: value)
            }
        }
        print("Price didn't parse properly")
        return nil
    }
    
    func parseThumbnails(json: Payload) -> [Thumbnail]? {
        if let thumbnail = json["thumbnail"] as? Payload {
            var list = [Thumbnail]()
            
            if let t = parseThumbnail(thumbnail) {
                list.append(t)
            }
            
            if let formats = thumbnail["formats"] as? [Payload] {
                list.appendContentsOf(formats.flatMap({ (format) -> Thumbnail? in
                    //checking if is double nested
                    let format = nestedValue(format, key: "formats")
                    return parseThumbnail(format)
                }))
            }
            return list
        }
        return nil
    }
    
    func parseThumbnail(json: Payload) -> Thumbnail? {
        guard let url = json["url"] as? String else {
            return nil
        }
        let width = json["width"] as? Int
        let height = json["height"] as? Int
        return Thumbnail(url: url, width: width, height: height)
    }
    
    func parseLinks(json: Payload) -> [(String, String)]? {
        var links: [Payload]?
        if let l = json["links"] as? [Payload] {
            links = l
        } else if let l = json["links"]?["link"] as? [Payload] {
            links = l
        }
        
        if let links = links {
            return links.flatMap({ (link) -> (String, String)? in
                let link = nestedValue(link, key: "link")
                if let type = link["type"] as? String, url = link["url"] as? String {
                    return (type, url)
                }
                return nil
            })
        }
        return nil
    }
    
    func parseRating(json: Payload) -> Rating? {
        guard let rating = json["rating"] as? Payload
            , user = rating["useraveragerating"] as? Payload
            , value = user["rating"] as? String, numComments = user["numcomments"] as? Int else {
            print("Rating didn't parse properly")
            return nil
        }
        let links   = parseLinks(user)
        let url     = links?.filter({ $0.0 == "xml" }).first?.1
        return Rating(value: value, numComments: numComments, url: url)
    }
    
    func parseSpecification(json: Payload) -> Specification? {
        guard let specification = json["specification"] as? Payload else {
            print("Specification didn't parse properly")
            return nil
        }
        let url = parseLinks(specification)?.filter({ $0.0 == "xml" }).first?.1
        let items = (specification["items"] as? [Payload])?.flatMap({ parseSpecificationItem($0) })
        return Specification(url: url, items: items)
    }
    
    func parseSpecificationItem(json: Payload) -> SpecificationItem? {
        guard let label = json["label"] as? String, value = json["value"] as? [String] else {
            return nil
        }
        return SpecificationItem(name: label, value: value)
    }
    
    func nestedValue(json: Payload, key:String) -> Payload {
        if let nest = json[key] as? Payload {
            return nest
        }
        return json
    }
}