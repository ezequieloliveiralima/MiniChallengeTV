//
//  QRCode.swift
//  MiniChallengeTV
//
//  Created by Ezequiel de Oliveira Lima on 16/05/16.
//  Copyright © 2016 BEPiD. All rights reserved.
//

import UIKit

class QRCode {
    var content: String!
    
    init(content: String) {
        self.content = content
    }
    
    func generate() -> UIImage {
        let data = content.dataUsingEncoding(NSISOLatin1StringEncoding, allowLossyConversion: false)
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter!.setValue(data, forKey: "inputMessage")
        filter!.setValue("Q", forKey: "inputCorrectionLevel")
        var out = filter!.outputImage!
        out = out.imageByApplyingTransform(CGAffineTransformMakeScale(40, 40))
        return UIImage(CIImage: out)
    }
}