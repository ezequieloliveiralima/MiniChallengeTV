//
//  BTopList.swift
//  BuscapeAPI
//
//  Created by William Cho on 5/12/16.
//  Copyright © 2016 wc. All rights reserved.
//

import Foundation


class BTopProducts : CustomStringConvertible {
    
    var detail: BListDetail!
    var products: [BProduct]!
    
    var description: String {
        return "{BTopProducts products: \(products.count), detail: \(detail)}"
    }
    
    init() {}
    
}

class BTopOffers : CustomStringConvertible {
    var detail: BListDetail!
    var offers: [BOffer]!
    
    var description: String {
        return "{BTopOffers products: \(offers.count), detail: \(detail)}"
    }
    
    init() {}
}

class BTopCategories : CustomStringConvertible {
    var detail: BListDetail!
    var categories: [BCategory]!
    
    var description: String {
        return "{BTopCategories products: \(categories.count), detail: \(detail)}"
    }
    
    init() {}
}

class BFindProduct : CustomStringConvertible {
    
    var detail: BListDetail!
    var offers: [BOffer]!
    var product: BProduct!
    var category: BCategory!
    
    var description: String {
        return "{BFindProduct offers: \(offers.count), detail: \(detail), product: \(product)}"
    }
}

////////////////////////////////////
struct BListDetail : CustomStringConvertible {
    
    var page: Int!
    var totalPages: Int!
    var totalResultsAvailable: Int!
    var totalResultsReturned: Int!
    
    var description: String {
        return "{page: \(page), total: \(totalPages), totalResults: \(totalResultsReturned), totalResultsAvailable: \(totalResultsAvailable)}"
    }
    
}

////////////////////////////////////
class BProduct {
    
    let id          : Int
    var idCategory  : Int!
    var name        : String!
    var nameShort   : String!
    var price       : Price!
    var userRating  : Rating!
    
    var url         : String!
    var detailUrl   : String!
    
    var thumbnailUrl    : String? //600x600
    var imageUrl        : String?
    var specification   : BSpecification?
    
    init(id: Int) {
        self.id = id
    }
}

class BOffer {
    
    let id              : Int
    var idCategory      : Int!
    var idProduct       : Int!
    var name            : String!
    var price           : Price!
    
    var url             : String!
    var thumbnailUrl    : String?
    
    var vendor          : BVendor!
    
    init(id: Int) {
        self.id = id
    }
    
}

class BVendor {
    
    let id: Int
    
    var name        : String!
    var userRating  : Rating!
    var url         : String!
    
    var thumbnailUrl : String?
    var contacts: [(name: String, value: String)]?
    
    init(id: Int) {
        self.id = id
    }
}

class BCategory {
    
    let id              : Int
    var idParent        : Int!
    var name            : String!
    var isFinal         : Bool!
    var hasOffer        : Bool!
    var hasProduct      : Bool!
    var productsUrl     : String!
    var offersUrl       : String!
    
    var thumbnailUrl    : String?
    
    init(id: Int) {
        self.id = id
    }
}

////////////////////////////////////
struct BProductDescription {
    let name: String
    let value: [String]
    
    init(name: String, value: [String]) {
        self.name = name
        self.value = value
    }
}

struct BSpecification {
    var url: String?
    var items: [(name: String, value: [String])]?
}

struct Rating {
    
    let value       : String
    let numComments : Int
    var url         : String?
    
    init(value: String, numComments: Int, url: String?) {
        self.value = value
        self.numComments = numComments
        self.url = url
    }
}

enum Price {
    case Range(min: Double, max: Double)
    case Parcel(value: Double, parcelValue: Double, interest: Double, parcel: Int)
    case Discount(value: Double, originalValue: Double, discountPercent: Double)
}