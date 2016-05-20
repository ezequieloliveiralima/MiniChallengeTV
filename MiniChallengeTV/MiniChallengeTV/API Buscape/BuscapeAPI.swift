//
//  BuscapeAPI.swift
//  BuscapeAPI
//
//  Created by William Cho on 5/12/16.
//  Copyright © 2016 wc. All rights reserved.
//

import Foundation

private enum BuscapeEnviromentType {
    case Sandbox, Production
}

class BuscapeAPI {
    
    private let BASE = "http://sandbox.buscape.com.br/service" //topCategories/{app-token}/BR/
    private let KEY = "4130577772346e466a48673d"
    
    private var enviromentType = BuscapeEnviromentType.Sandbox
    
    private var searchType  : SearchType
    private var parameters  = [SearchParameter]()
    
    init(searchType: SearchType) {
        self.searchType = searchType
    }
    
    func setSearch(searchType: SearchType) -> BuscapeAPI {
        self.searchType = searchType
        return self
    }
    
    func setFormat(type: SearchParameter.FormatType) -> BuscapeAPI {
        
        return self
    }
    
    func addParameter(parameter: SearchParameter) -> BuscapeAPI {
        if let index = parameters.indexOf({ $0.equals(parameter) }) {
            parameters[index] = parameter
        } else {
            parameters.append(parameter)
        }
        return self
    }
    
    func addParameters(params: [SearchParameter]) -> BuscapeAPI {
        self.parameters.appendContentsOf(params)
        return self
    }
    
    func addParameters(params: SearchParameter...) -> BuscapeAPI {
        self.parameters.appendContentsOf(params)
        return self
    }
    
    func removeParameter(parameter: SearchParameter) -> BuscapeAPI {
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
        case .Product           : uri += "/findProductList"
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
                case .Sort      (let type)      :
                    switch type {
                    case .Price : return "sort=price"
                    case .DPrice: return "sort=dprice"
                    case .Rate  : return "sort=rate"
                    case .DRate : return "sort=drate"
                    }
                case .Medal     (let type)      :
                    switch type {
                    case .All       : return "medal=all"
                    case .Bronze    : return "medal=bronze"
                    case .Silver    : return "medal=silver"
                    case .Gold      : return "medal=gold"
                    case .Diamond   : return "medal=diamond"
                    }
                case .Format    (let type)      : return "format=\(type.rawValue)"
                }
            }).joinWithSeparator("&")
        }

        return uri
    }
    
}

