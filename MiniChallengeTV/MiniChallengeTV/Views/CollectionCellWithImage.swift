//
//  CollectionCellWithImage.swift
//  MiniChallengeTV
//
//  Created by Ezequiel de Oliveira Lima on 17/05/16.
//  Copyright © 2016 BEPiD. All rights reserved.
//

import UIKit

class CollectionCellWithImage: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        if context.nextFocusedView == self {
            self.transform = CGAffineTransformMakeScale(1.02, 1.02)
        } else {
            self.transform = CGAffineTransformMakeScale(1, 1)
        }
    }
}
