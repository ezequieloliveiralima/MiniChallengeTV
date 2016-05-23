//
//  TopList.swift
//  MiniChallengeTV
//
//  Created by William Cho on 5/17/16.
//  Copyright © 2016 BEPiD. All rights reserved.
//

import Foundation

class List<Element : BaseModel> : CustomStringConvertible {
    
    let detail: Detail
    let list: [Element]
    
    init<T: BuscapeModel>(list: BList<T>) {
        self.detail = Detail(data: list.detail)!
        self.list = list.list.flatMap({ Element.init(data: $0) })
    }
    
    var description: String {
        return "{\(detail), list:\(list)}"
    }
    
}

class ProductOffers: CustomStringConvertible {
    
    let detail  : Detail
    let product : Product
    let category: Category
    let offers  : [Offer]
    
    init(detail: BListDetail, product: BProduct, category: BCategory, offers: [BOffer]) {
        self.detail = Detail(data: detail)
        self.product = Product(data: product)
        self.category = Category(data: category)
        self.offers = offers.map({ Offer(data: $0) })
    }
    
    var description: String {
        return "{\(detail), category:\(category), product:\(product), offers:\(offers)}"
    }
}

