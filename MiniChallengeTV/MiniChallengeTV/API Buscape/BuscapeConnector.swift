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
    
    func openConnection(uri: String, completionHandler: (Payload?, NSURLResponse?, NSError?) -> Void) {
        ConnectionManager.openConnection(uri) { (data, response, error) in
            do {
                var json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? Payload
                json = BuscapeParser.changeKeyToLower(&json!)
                completionHandler(json, response, error)
            } catch _ {
                print("JSON Serialization Error")
            }
        }
    }
    
    func openConnection(type type: SearchType, parameters: [SearchParameter], completionHandler:((Payload?, NSURLResponse?, NSError?) -> Void)) {
        var parameters = parameters
        parameters.append(.Format(.JSON))
        let uri = BuscapeAPI(searchType: type).addParameters(parameters).getURI()
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
    
    func getProductOffers(id: Int, parameters: [SearchParameter], callback: (BListDetail, BProduct, BCategory, [BOffer]) -> Void) {
        var parameters = parameters
        parameters.append(.ProductId(id))
        openConnection(type: .Offer, parameters: parameters) { (json, response, error) in
            guard let json = json
                , offersJson = json["offer"] as? [Payload]
                , productJson = json["product"]?[0]?["product"] as? Payload
                , categoryJson = json["category"] as? Payload
                , detail = BuscapeParser.parseListDetail(json)
                , product = BuscapeParser.parseProduct(productJson)
                , category = BuscapeParser.parseCategory(categoryJson) else {
                    print("TODO error getting product offers \(id)")
                    return
            }
            
            let offers = offersJson.flatMap({ BuscapeParser.parseOffer($0) })
            callback(detail, product, category, offers)
        }
    }
}

