//
//  Extensions.swift
//  MiniChallengeTV
//
//  Created by William Cho on 5/19/16.
//  Copyright © 2016 BEPiD. All rights reserved.
//

import UIKit

extension Array {
    
}

extension UIViewController {
    
    
    
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
}