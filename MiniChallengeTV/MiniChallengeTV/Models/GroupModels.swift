//
//  TopList.swift
//  MiniChallengeTV
//
//  Created by William Cho on 5/17/16.
//  Copyright © 2016 BEPiD. All rights reserved.
//

import Foundation

class TopList<Element : BaseModel> : CustomStringConvertible {
    
    var page: Int
    var totalPages: Int
    var totalResultsReturned: Int
    var totalResultsAvailable: Int
    var list: [Element]
    
    init<T: BuscapeModel>(list: BList<T>) {
        self.page = list.detail.page
        self.totalPages = list.detail.totalPages
        self.totalResultsReturned = list.detail.totalResultsReturned
        self.totalResultsAvailable = list.detail.totalResultsAvailable
        self.list = list.list.flatMap({ (Element.self as Element.Type).init(data: $0) })
    }
    
    var description: String {
        return "{page: \(page), total: \(totalPages), totalResults: \(totalResultsReturned), totalResultsAvailable: \(totalResultsAvailable), list:\(list)}"
    }
}

