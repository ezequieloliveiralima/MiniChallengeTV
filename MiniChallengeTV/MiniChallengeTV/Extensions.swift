//
//  Extensions.swift
//  MiniChallengeTV
//
//  Created by William Cho on 5/19/16.
//  Copyright © 2016 BEPiD. All rights reserved.
//

import UIKit

extension Array {
    
    mutating func add(newElement: Element) -> Array<Element> {
        self.append(newElement)
        return self
    }
    
    mutating func addContentsOf<S : SequenceType where S.Generator.Element == Element>(newElements: S) -> Array<Element> {
        self.appendContentsOf(newElements)
        return self
    }
    
    public mutating func addContentsOf<C : CollectionType where C.Generator.Element == Element>(newElements: C) -> Array<Element> {
        self.appendContentsOf(newElements)
        return self
    }

}

extension UIImage {
    func imageByMakingWhiteBackgroundTransparent() -> UIImage? {
        if let rawImageRef = self.CGImage {
            let colorMasking: [CGFloat] = [200, 255, 200, 255, 200, 255]
            UIGraphicsBeginImageContext(self.size)
            if let maskedImageRef = CGImageCreateWithMaskingColors(rawImageRef, colorMasking) {
                CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0.0, self.size.height)
                CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1.0, -1.0)
                CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, self.size.width, self.size.height), maskedImageRef)
                let result = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                return result
            }
        }
        return nil
    }
    
    class func defaultImage() -> UIImage? {
        return UIImage(named: "placeholder")
    }
}

extension UIViewController {
    func performSegueWithIdentifier(identifier: SegueIdentifier, sender: AnyObject?) {
        self.performSegueWithIdentifier(identifier.rawValue, sender: sender)
    }
}

extension UICollectionView {
    
    func registerClass(cellClass: AnyClass?, forCellWithReuseIdentifier identifier: CellIdentifier) {
        self.registerClass(cellClass, forCellWithReuseIdentifier: identifier.rawValue)
    }
    
    func registerNib(nib: UINib?, forCellWithReuseIdentifier identifier: CellIdentifier) {
        self.registerNib(nib, forCellWithReuseIdentifier: identifier.rawValue)
    }
    
    func registerClass(viewClass: AnyClass?, forSupplementaryViewOfKind elementKind: String, withReuseIdentifier identifier: CellIdentifier) {
        self.registerClass(viewClass, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: identifier.rawValue)
    }
    
    func registerNib(nib: UINib?, forSupplementaryViewOfKind kind: String, withReuseIdentifier identifier: CellIdentifier) {
        self.registerNib(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier.rawValue)
    }
    
    func dequeueReusableCellWithReuseIdentifier(identifier: CellIdentifier, forIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return self.dequeueReusableCellWithReuseIdentifier(identifier.rawValue, forIndexPath: indexPath)
    }
    
    func dequeueReusableSupplementaryViewOfKind(elementKind: String, withReuseIdentifier identifier: CellIdentifier, forIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        return self.dequeueReusableSupplementaryViewOfKind(elementKind, withReuseIdentifier: identifier.rawValue, forIndexPath: indexPath)
    }
    
}

extension UITableView {
    
    func registerNib(nib: UINib?, forCellReuseIdentifier identifier: CellIdentifier) {
        self.registerNib(nib, forCellReuseIdentifier: identifier.rawValue)
    }
    
    func registerClass(cellClass: AnyClass?, forCellReuseIdentifier identifier: CellIdentifier) {
        self.registerClass(cellClass, forCellReuseIdentifier: identifier.rawValue)
    }
    
    func dequeueReusableCellWithIdentifier(identifier: CellIdentifier) -> UITableViewCell? {
        return self.dequeueReusableCellWithIdentifier(identifier.rawValue)
    }
    
    func dequeueReusableCellWithIdentifier(identifier: CellIdentifier, forIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return self.dequeueReusableCellWithIdentifier(identifier.rawValue, forIndexPath: indexPath)
    }
    
    func dequeueReusableHeaderFooterViewWithIdentifier(identifier: CellIdentifier) -> UITableViewHeaderFooterView? {
        return self.dequeueReusableHeaderFooterViewWithIdentifier(identifier.rawValue)
    }
    
}

extension CALayer {
    var borderUIColor: UIColor {
        set {
            self.borderColor = newValue.CGColor
        }
        
        get {
            return UIColor(CGColor: self.borderColor!)
        }
    }
}