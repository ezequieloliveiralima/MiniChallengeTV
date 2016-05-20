//
//  GenericCollectionCell.swift
//  MiniChallengeTV
//
//  Created by Ezequiel de Oliveira Lima on 19/05/16.
//  Copyright © 2016 BEPiD. All rights reserved.
//

import UIKit

class GenericCollectionCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocusInContext(context, withAnimationCoordinator: coordinator)
        
        if context.nextFocusedView == self {
            UIView.animateWithDuration(0.3, animations: { 
                self.transform = CGAffineTransformMakeScale(1.3, 1.3)
            })
        } else {
            UIView.animateWithDuration(0.3, animations: {
                self.transform = CGAffineTransformMakeScale(1, 1)
            })
        }
    }
}
