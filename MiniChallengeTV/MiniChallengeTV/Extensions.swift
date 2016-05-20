//
//  Extensions.swift
//  MiniChallengeTV
//
//  Created by William Cho on 5/19/16.
//  Copyright © 2016 BEPiD. All rights reserved.
//

import Foundation

extension Array {
    
    func append<T>(newElement: T) -> Array<Element> {
        self.append(newElement)
        return self
    }

    func appendContentsOf<T>(newElements: T) -> Array<Element> {
        appendContentsOf(newElements)
        return self
    }
    
}