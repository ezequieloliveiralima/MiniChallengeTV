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
                json = BuscapeParser.changeKeyToLower(&json!)
//                print(json)
                completionHandler(json, response, error)
            } catch _ {
                print("JSON Serialization Error")
            }
        }).resume()
    }
    
    func openConnection(type type: SearchType, parameters: [SearchParameter], completionHandler:((Payload?, NSURLResponse?, NSError?) -> Void)) {
        let uri = BuscapeAPI(searchType: type).addParameters([SearchParameter.Format(.JSON)].appendContentsOf(parameters)).getURI()
        openConnection(uri, completionHandler: completionHandler)
    }
    
    func getList<T: BuscapeModel>(searchType: SearchType, parameters: [SearchParameter], callback: (BList<T>) -> Void) {
        openConnection(type: searchType, parameters: parameters) { (json, response, error) in
            guard let json = json
                , detail = BuscapeParser.parseListDetail(json) else {
                return
            }
            
            let key: String, parse: (Payload) -> T? 
            
            switch searchType {
            case .TopProducts, .Product:
                key = "product"
                parse = { (data: Payload) -> T? in  BuscapeParser.parseProduct(data) as? T }
            case .TopOffers, .Offer:
                key = "offer"
                parse = { (data: Payload) -> T? in  BuscapeParser.parseOffer(data) as? T }
            case .TopCategories, .Category:
                key = "subcategory"
                parse = { (data: Payload) -> T? in  BuscapeParser.parseCategory(data) as? T }
            default: return
            }
            
            guard let l = json[key] as? [Payload] else {
                return
            }
            
            let list = l.flatMap({ parse($0) })
            let top = BList<T>(detail: detail, list: list)
            callback(top)
        }
    }
    
    func getProductOffers(id: Int, callback: (BProductOffers) -> Void) {
        openConnection(type: .TopOffers, parameters: [.ProductId(id)]) { (json, response, error) in
            guard let json = json
                , offersJson = json["offer"] as? [Payload]
                , productJson = json["product"]?[0]?["product"] as? Payload
                , categoryJson = json["category"] as? Payload
                , detail = BuscapeParser.parseListDetail(json)
                , product = BuscapeParser.parseProduct(productJson)
                , category = BuscapeParser.parseCategory(categoryJson) else {
                    print("TODO error getting Product by Id")
                    return
            }
            
            let offers = offersJson.flatMap({ BuscapeParser.parseOffer($0) })
            let result = BProductOffers(detail: detail, product: product, category: category, offers: offers)
            callback(result)
        }
    }
}

