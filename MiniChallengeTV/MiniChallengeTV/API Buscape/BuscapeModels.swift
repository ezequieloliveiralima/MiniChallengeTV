//
//  BTopList.swift
//  BuscapeAPI
//
//  Created by William Cho on 5/12/16.
//  Copyright © 2016 wc. All rights reserved.
//

import Foundation

protocol BuscapeModel {
    
}

////////////////////////////////////
class BProduct: BuscapeModel {
    
    let id          : Int
    let idCategory  : Int
    let name        : String
    let nameShort   : String
    let price       : Price?
    let userRating  : Rating
    
    let url         : String
    let detailUrl   : String
    
    let thumbnails      : [Thumbnail]?
    let specification   : Specification?
    
    init(id: Int, idCategory: Int, name: String, nameShort: String, price: Price?, rating: Rating, url: String, detail: String, thumbnails: [Thumbnail]?, specification: Specification?) {
        self.id             = id
        self.idCategory     = idCategory
        self.name           = name
        self.nameShort      = nameShort
        self.price          = price
        self.userRating     = rating
        self.url            = url
        self.detailUrl      = detail
        self.thumbnails     = thumbnails
        self.specification  = specification
    }
}

class BCategory: BuscapeModel {
    
    let id              : Int
    let idParent        : Int
    let name            : String
    let isFinal         : Bool
    let productsUrl     : String?
    let offersUrl       : String?
    let thumbnail       : Thumbnail?
    
    init(id: Int, idParent: Int, name: String, isFinal: Bool, productsUrl: String?, offersUrl: String?, thumbnail: Thumbnail?) {
        self.id             = id
        self.idParent       = idParent
        self.name           = name
        self.isFinal        = isFinal
        self.productsUrl    = productsUrl
        self.offersUrl      = offersUrl
        self.thumbnail      = thumbnail
    }
}

class BOffer: BuscapeModel {
    
    let id              : Int
    let idCategory      : Int
    let idProduct       : Int
    let name            : String
    let price           : Price
    let url             : String
    let thumbnail       : Thumbnail?
    let vendor          : BVendor
    
    init(id: Int, idCategory: Int, idProduct: Int, name: String, price: Price, url: String, thumbnail: Thumbnail?, vendor: BVendor) {
        self.id         = id
        self.idCategory = idCategory
        self.idProduct  = idProduct
        self.name       = name
        self.price      = price
        self.url        = url
        self.thumbnail  = thumbnail
        self.vendor     = vendor      
    }
    
}

class BVendor: BuscapeModel {
    
    let id          : Int
    let name        : String
    let userRating  : Rating
    let url         : String?
    let thumbnail   : Thumbnail?
    
    init(id: Int, name: String, rating: Rating, url: String?, thumbnail: Thumbnail?) {
        self.id           = id
        self.name         = name
        self.userRating   = rating
        self.url          = url
        self.thumbnail    = thumbnail
    }
}

class BListDetail : BuscapeModel, CustomStringConvertible {
    
    let page: Int?
    let totalPages: Int?
    let totalResultsAvailable: Int
    let totalResultsReturned: Int
    
    var description: String {
        return "{page: \(page), total: \(totalPages), totalResults: \(totalResultsReturned), totalResultsAvailable: \(totalResultsAvailable)}"
    }
    
    init(page: Int?, totalPages: Int?, totalResultsReturned: Int, totalResultsAvailable: Int) {
        self.page = page
        self.totalPages = totalPages
        self.totalResultsReturned = totalResultsReturned
        self.totalResultsAvailable = totalResultsAvailable
    }
    
}