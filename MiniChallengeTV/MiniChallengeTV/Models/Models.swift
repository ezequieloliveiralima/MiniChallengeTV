//
//  Models.swift
//  MiniChallengeTV
//
//  Created by William Cho on 5/19/16.
//  Copyright © 2016 BEPiD. All rights reserved.
//

import Foundation

protocol BaseModel {
    init?(data: BuscapeModel)
}

class Product: BaseModel, CustomStringConvertible {
    
    let id              : Int
    let idCategory      : Int
    let name            : String
    let nameShort       : String
    let price           : Price?
    let userRating      : Rating
    let url             : String
    let detailUrl       : String
    let thumbnails      : [Thumbnail]?
    let specification   : Specification?
    
    required init?(data: BuscapeModel) {
        guard let data = data as? BProduct else {
            return nil
        }
        self.id         = data.id
        self.idCategory = data.idCategory
        self.name       = data.name
        self.nameShort  = data.nameShort
        self.price      = data.price
        self.userRating = data.userRating
        self.url        = data.url
        self.detailUrl  = data.detailUrl
        self.thumbnails = data.thumbnails
        self.specification = data.specification
    }
    
    init(data: BProduct) {
        self.id         = data.id
        self.idCategory = data.idCategory
        self.name       = data.name
        self.nameShort  = data.nameShort
        self.price      = data.price
        self.userRating = data.userRating
        self.url        = data.url
        self.detailUrl  = data.detailUrl
        self.thumbnails = data.thumbnails
        self.specification = data.specification
    }
    
    var description: String {
        return "{id:\(id), name:\(name), price:\(price)}"
    }
    
    var imageUrl: String? {
        return thumbnails?.maxElement({ $0.0.width > $0.1.width })?.url
    }
}

class Offer: BaseModel, CustomStringConvertible {
    
    let id              : Int
    let idCategory      : Int
    let idProduct       : Int
    let name            : String
    let price           : Price
    let url             : String
    let thumbnail       : Thumbnail?
    let vendor          : Vendor
    
    required init?(data: BuscapeModel) {
        guard let data = data as? BOffer else {
            return nil
        }
        self.id         = data.id
        self.idCategory = data.idCategory
        self.idProduct  = data.idProduct
        self.name       = data.name
        self.price      = data.price
        self.url        = data.url
        self.thumbnail  = data.thumbnail
        self.vendor     = Vendor(data: data.vendor)
    }
    
    init(data: BOffer) {
        self.id         = data.id
        self.idCategory = data.idCategory
        self.idProduct  = data.idProduct
        self.name       = data.name
        self.price      = data.price
        self.url        = data.url
        self.thumbnail  = data.thumbnail
        self.vendor     = Vendor(data: data.vendor)
    }
    
    var description: String {
        return ""
    }
    
    var imageUrl: String? {
        return thumbnail?.url
    }
}

class Vendor: BaseModel, CustomStringConvertible {
    
    let id          : Int
    let name        : String
    let userRating  : Rating
    let url         : String?
    let thumbnail   : Thumbnail?
    
    required init?(data: BuscapeModel) {
        guard let data = data as? BVendor else {
            return nil
        }
        self.id           = data.id
        self.name         = data.name
        self.userRating   = data.userRating
        self.url          = data.url
        self.thumbnail    = data.thumbnail
    }
    
    init(data: BVendor) {
        self.id           = data.id
        self.name         = data.name
        self.userRating   = data.userRating
        self.url          = data.url
        self.thumbnail    = data.thumbnail
    }
    
    var description: String {
        return ""
    }
    
    var imageUrl: String? {
        return thumbnail?.url
    }
}

class Category: BaseModel, CustomStringConvertible {
    
    let id              : Int
    let idParent        : Int
    let name            : String
    let isFinal         : Bool
    let productsUrl     : String?
    let offersUrl       : String?
    let thumbnail       : Thumbnail?
    
    required init?(data: BuscapeModel) {
        guard let data = data as? BCategory else {
            return nil
        }
        self.id             = data.id
        self.idParent       = data.idParent
        self.name           = data.name
        self.isFinal        = data.isFinal
        self.productsUrl    = data.productsUrl
        self.offersUrl      = data.offersUrl
        self.thumbnail      = data.thumbnail
    }
    
    init(data: BCategory) {
        self.id             = data.id
        self.idParent       = data.idParent
        self.name           = data.name
        self.isFinal        = data.isFinal
        self.productsUrl    = data.productsUrl
        self.offersUrl      = data.offersUrl
        self.thumbnail      = data.thumbnail
    }
    
    var description: String {
        return ""
    }
    
    var imageUrl: String? {
        return thumbnail?.url
    }
}

class Detail: BaseModel, CustomStringConvertible {
    let page: Int?
    let totalPages: Int?
    let totalResultsReturned: Int
    let totalResultsAvailable: Int
    
    required init?(data: BuscapeModel) {
        guard let data = data as? BListDetail else {
            return nil
        }
        
        self.page                   = data.page
        self.totalPages             = data.totalPages
        self.totalResultsReturned   = data.totalResultsReturned
        self.totalResultsAvailable  = data.totalResultsAvailable
    }
    
    init(data: BListDetail) {
        self.page                   = data.page
        self.totalPages             = data.totalPages
        self.totalResultsReturned   = data.totalResultsReturned
        self.totalResultsAvailable  = data.totalResultsAvailable
    }
    
    var description: String {
        return "{page: \(page), total: \(totalPages), totalResults: \(totalResultsReturned), totalResultsAvailable: \(totalResultsAvailable)}"
    }
}