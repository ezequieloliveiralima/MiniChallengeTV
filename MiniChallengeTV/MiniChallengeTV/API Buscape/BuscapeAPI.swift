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
    , Offer(id: Int), Category(id: Int), Product(id: Int)
    , UserRatings
}

enum BuscapeEnviromentType {
    case Sandbox, Production
}

enum ApplicationResponseType: String {
    case JSON = "json", XML = "xml"
}

class BuscapeAPI {
    
    private let BASE = "http://sandbox.buscape.com.br/service" //topCategories/{app-token}/BR/
    private let KEY = "4130577772346e466a48673d"
    
    private var enviromentType = BuscapeEnviromentType.Sandbox
    
    private var searchType: BuscapeSearchType
    private var format      = ApplicationResponseType.JSON
    private var parameters = [(key: String, value: String)]()
    
    init(type: BuscapeSearchType) {
        self.searchType = type
    }
    
    func setSearchType(type: BuscapeSearchType) -> BuscapeAPI {
        self.searchType = type
        return self
    }
    
    func setFormat(format: ApplicationResponseType) -> BuscapeAPI {
        self.format = format
        return self
    }
    
    func setParameter(key: String, value: String) -> BuscapeAPI {
        if let index = parameters.indexOf({ $0.key == key }) {
            parameters[index].value = value
        } else {
            parameters.append((key, value))
        }
        return self
    }
    
    func removeParameter(key: String) -> BuscapeAPI {
        if let index = parameters.indexOf({ $0.key == key }) {
            parameters.removeAtIndex(index)
        }
        return self
    }
    
    func clear() -> BuscapeAPI {
        return self
    }
    
    func getURI() -> String {
        var uri = BASE
        switch searchType {
        case .TopOffers         : uri += "/v2/topOffers/buscape"
        case .TopProducts       : uri += "/v2/topProducts"
        case .TopCategories     : uri += "/v2/topCategories"
        case .UserRatings       : uri += "/v2/userRatings"
        case .Product(let id)   : uri += "/findOfferList"
            setParameter("productId", value: String(id))
        default: break
        }
        
        uri += "/\(KEY)/BR/?format=\(format.rawValue)"
        if !parameters.isEmpty {
            uri += "&" + parameters.map({"\($0.key)=\($0.value)"}).joinWithSeparator("&")
        }
        return uri
    }
    
}

enum BuscapeAPIError : ErrorType {
    case InvalidData
}