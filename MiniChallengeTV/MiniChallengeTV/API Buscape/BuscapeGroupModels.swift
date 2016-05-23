//
//  BuscapeGroupModels.swift
//  MiniChallengeTV
//
//  Created by William Cho on 5/19/16.
//  Copyright © 2016 BEPiD. All rights reserved.
//

import Foundation


class BList<Element : BuscapeModel> : CustomStringConvertible {
    
    let detail  : BListDetail
    let list    : [Element]
    
    init(detail: BListDetail, list: [Element]) {
        self.list = list
        self.detail = detail
    }
    
    var description: String {
        return "{detail:\(detail), list:\(list)}"
    }
}

class BProductOffers: BuscapeModel, CustomStringConvertible {
    
    var detail  : BListDetail
    var product : BProduct
    var category: BCategory
    var offers  : [BOffer]
    
    init(detail: BListDetail, product: BProduct, category: BCategory, offers: [BOffer]) {
        self.detail = detail
        self.product = product
        self.category = category
        self.offers = offers
    }
    
    var description: String {
        return "{BFindProduct offers: \(offers.count), detail: \(detail), product: \(product)}"
    }
}



