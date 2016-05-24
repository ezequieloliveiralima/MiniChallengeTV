//
//  BuscapeParser.swift
//  MiniChallengeTV
//
//  Created by William Cho on 5/19/16.
//  Copyright © 2016 BEPiD. All rights reserved.
//

import Foundation

class BuscapeParser {
    
    class func changeKeyToLower(inout payload: Payload) -> Payload {
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
    
    class func parseListDetail(json: Payload) -> BListDetail? {
        guard let totalResultsReturned = json["totalresultsreturned"] as? Int
            , totalResultsAvailable = json["totalresultsavailable"] as? Int else {
                return nil
        }
        let page = json["page"] as? Int
        let totalPages = json["totalpages"] as? Int
        return BListDetail(page: page, totalPages: totalPages, totalResultsReturned: totalResultsReturned, totalResultsAvailable: totalResultsAvailable)
    }
    
    class func parseCategory(json: Payload) -> BCategory? {
        let json = nestedValue(json, key: "subcategory")
        guard let id        = json["id"] as? Int
            , idParent      = json["parentcategoryid"] as? Int
            , name          = json["name"] as? String
            , isFinal       = json["isfinal"] as? Bool
            , links         = parseLinks(json)
            else {
                print("Category didn't parse properly")
                return nil
        }
        
        let thumbnail   = parseThumbnail(json)
        let productUrl  = links.filter({ $0.0 == "list_product" }).first?.0
        let offerUrl    = links.filter({ $0.0 == "list_offer" }).first?.0
        return BCategory(id: id, idParent: idParent, name: name, isFinal: isFinal, productsUrl: productUrl, offersUrl: offerUrl, thumbnail: thumbnail)
    }
    
    class func parseProduct(json: Payload) -> BProduct? {
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
    
    class func parseOffer(json: Payload) -> BOffer? {
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
    
    class func parseVendor(json: Payload) -> BVendor? {
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
    
    class func parsePrice(json: Payload) -> Price? {
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
    
    class func parseThumbnails(json: Payload) -> [Thumbnail]? {
        if let thumbnail = json["thumbnail"] as? Payload {
            var list = [Thumbnail]()
            
            if let t = parseThumbnail(thumbnail) {
                list.append(t)
            }
            
            if let formats =  thumbnail["formats"] as? [Payload] {
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
    
    class func parseThumbnail(json: Payload) -> Thumbnail? {
        let json = nestedValue(json, key: "thumbnail")
        guard let url = json["url"] as? String else {
            return nil
        }
        let width = json["width"] as? Int
        let height = json["height"] as? Int
        return Thumbnail(url: url, width: width, height: height)
    }
    
    class func parseLinks(json: Payload) -> [(String, String)]? {
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
    
    class func parseRating(json: Payload) -> Rating? {
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
    
    class func parseSpecification(json: Payload) -> Specification? {
        guard let specification = json["specification"] as? Payload else {
            print("Specification didn't parse properly")
            return nil
        }
        let url = parseLinks(specification)?.filter({ $0.0 == "xml" }).first?.1
        let items = ((specification["items"] ?? specification["item"]) as? [Payload])?.flatMap({ parseSpecificationItem($0) })
        return Specification(url: url, items: items)
    }
    
    class func parseSpecificationItem(json: Payload) -> SpecificationItem? {
        let json = nestedValue(json, key: "item")
        guard let label = json["label"] as? String, value = json["value"] as? [String] else {
            return nil
        }
        return SpecificationItem(name: label, value: value)
    }
    
    class func nestedValue(json: Payload, key:String) -> Payload {
        if let nest = json[key] as? Payload {
            return nest
        }
        return json
    }
}