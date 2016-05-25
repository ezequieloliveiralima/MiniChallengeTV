//
//  Constants.swift
//  MiniChallengeTV
//
//  Created by William Cho on 5/23/16.
//  Copyright © 2016 BEPiD. All rights reserved.
//

import Foundation

enum CellIdentifier: String {
    
    case Default = "default-cell"
    , Specification = "specification"
    , Order = "order"
    , Product = "product"

}

enum SegueIdentifier: String {
    case CategorySelected = "category_selected"
        , ProductSelected = "product_selected"
        , ProductSearched = "product_searched"
    
}