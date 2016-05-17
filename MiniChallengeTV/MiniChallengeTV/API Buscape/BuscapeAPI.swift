//
//  BuscapeAPI.swift
//  BuscapeAPI
//
//  Created by William Cho on 5/12/16.
//  Copyright © 2016 wc. All rights reserved.
//

import Foundation

enum BuscapeSearchType {
    case TopOffers, TopCategories, TopProducts
    , Offer, Category, Product
    , Vendor, UserRatings
}

enum BuscapeSearchParameter {
    case ProductId(Int)
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
    
    func equals(other: BuscapeSearchParameter) -> Bool {
        switch (self, other) {
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
    
    enum SortType: String {
        case Price = "price", DPrice = "dprice", Rate = "rate", DRate = "drate"
    }
    
    enum VendorMedalType: String {
        case All = "all", Diamond = "diamond", Gold = "gold", Silver = "silver", Bronze = "bronze"
    }
    
    enum FormatType: String {
        case JSON = "json", XML = "xml"
    }
}



private enum BuscapeEnviromentType {
    case Sandbox, Production
}


class BuscapeAPI {
    
    private let BASE = "http://sandbox.buscape.com.br/service" //topCategories/{app-token}/BR/
    private let KEY = "4130577772346e466a48673d"
    
    private var enviromentType = BuscapeEnviromentType.Sandbox
    
    private var searchType  : BuscapeSearchType
    private var parameters  = [BuscapeSearchParameter]()
    
    init(searchType: BuscapeSearchType) {
        self.searchType = searchType
    }
    
    func setSearch(searchType: BuscapeSearchType) -> BuscapeAPI {
        self.searchType = searchType
        return self
    }
    
    func setFormat(type: BuscapeSearchParameter.FormatType) -> BuscapeAPI {
        
        return self
    }
    
    func addParameter(parameter: BuscapeSearchParameter) -> BuscapeAPI {
        if let index = parameters.indexOf({ $0.equals(parameter) }) {
            parameters[index] = parameter
        } else {
            parameters.append(parameter)
        }
        return self
    }
    
    func addParameters(params: BuscapeSearchParameter...) -> BuscapeAPI {
        params.forEach({ addParameter($0) })
        return self
    }
    
    func removeParameter(parameter: BuscapeSearchParameter) -> BuscapeAPI {
        if let index = parameters.indexOf({ $0.equals(parameter) }) {
            parameters.removeAtIndex(index)
        }
        return self
    }
    
    func removeAllParameters() -> BuscapeAPI {
        parameters.removeAll()
        return self
    }
    
    func getURI() -> String {
        var uri = BASE
        
        switch searchType {
        case .TopOffers         : uri += "/v2/topOffers/buscape"
        case .TopProducts       : uri += "/v2/topProducts"
        case .TopCategories     : uri += "/v2/topCategories"
        case .UserRatings       : uri += "/viewUserRatings"
        case .Product           : uri += "/findOfferList"
        case .Category          : uri += "/findCategoryList"
        case .Offer             : uri += "/findOfferList"
        case .Vendor            : uri += "/viewSellerDetails"
        }
        
        uri += "/\(KEY)/BR/"
        
        if !parameters.isEmpty {
            uri += "?" + parameters.map({ (p) -> String in
                switch p {
                case .ProductId (let id)        : return "productId=\(id)"
                case .CategoryId(let id)        : return "categoryId=\(id)"
                case .OfferId   (let id)        : return "offerId=\(id)"
                case .SourceId  (let id)        : return "resourceId=\(id)"
                case .Keyword   (let keyword)   : return "keyword=\(keyword)"
                case .PriceMin  (let min)       : return "priceMin=\(min)"
                case .PriceMax  (let max)       : return "priceMax=\(max)"
                case .Page      (let page)      : return "page=\(page)"
                case .Results   (let results)   : return "results=\(results)"
                case .Sort      (let type)      : return "sort=\(type.rawValue)"
                case .Medal     (let type)      : return "medal=\(type.rawValue)"
                case .Format    (let type)      : return "format=\(type.rawValue)"
                }
            }).joinWithSeparator("&")
        }

        return uri
    }
    
}

