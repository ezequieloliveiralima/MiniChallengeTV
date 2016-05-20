//
//  Common.swift
//  MiniChallengeTV
//
//  Created by William Cho on 5/18/16.
//  Copyright © 2016 BEPiD. All rights reserved.
//

import Foundation

enum SearchType {
    case TopOffers, TopCategories, TopProducts
    , Offer, Category, Product
    , Vendor, UserRatings
}

enum SearchParameter {
    case None
    , ProductId(Int)
    , CategoryId(Int)
    , OfferId(Int)
    , SourceId(Int)
    , Keyword(String)
    , PriceMin(Double)
    , PriceMax(Double)
    , Page(Int)
    , Results(Int)
    , Sort(SortType)
    , Medal(VendorMedalType)
    , Format(FormatType)
    
    func equals(other: SearchParameter) -> Bool {
        switch (self, other) {
        case (.None             , .None)            : return true
        case (.ProductId(_)     , .ProductId(_))    : return true
        case (.CategoryId(_)    , .CategoryId(_))   : return true
        case (.OfferId(_)       , .OfferId(_))      : return true
        case (.SourceId(_)      , .SourceId(_))     : return true
        case (.Keyword(_)       , .Keyword(_))      : return true
        case (.PriceMin(_)      , .PriceMin(_))     : return true
        case (.PriceMax(_)      , .PriceMax(_))     : return true
        case (.Page(_)          , .Page(_))         : return true
        case (.Results(_)       , .Results(_))      : return true
        case (.Sort(_)          , .Sort(_))         : return true
        case (.Medal(_)         , .Medal(_))        : return true
        case (.Format(_)        , .Format(_))       : return true
        default: return false
        }
    }
    
    enum SortType {
        case Price, DPrice, Rate, DRate
    }
    
    enum VendorMedalType {
        case All, Bronze, Silver, Gold, Diamond
    }
    
    enum FormatType: String {
        case JSON = "json", XML = "xml"
    }
}

struct Specification {
    let url: String?
    let items: [SpecificationItem]?
    
    init(url: String?, items: [SpecificationItem]?) {
        self.url = url
        self.items = items
    }
}

struct SpecificationItem {
    let name: String
    let value: [String]
    
    init(name: String, value: [String]) {
        self.name = name
        self.value = value
    }
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

struct Thumbnail {
    let url: String
    let width: Int?
    let height: Int?
    
    init(url: String, width: Int?, height: Int?) {
        self.url = url
        self.width = width
        self.height = height
    }
}

enum Price {
    case Value(value: Double)
    case Range(min: Double, max: Double)
    case Parcel(value: Double, parcelValue: Double, interest: Double, parcel: Int)
    case Discount(value: Double, originalValue: Double, discountPercent: Double)
}