//
//  MainViewControllerDelegate.swift
//  MiniChallengeTV
//
//  Created by William Cho on 5/20/16.
//  Copyright © 2016 BEPiD. All rights reserved.
//

import UIKit

class MainViewControllerDelegate: NSObject, UITabBarControllerDelegate {
    
    
    override init() {
        super.init()
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        if let controller = viewController as? UINavigationController {
            controller.delegate = self
        }
    }
    
}

extension MainViewControllerDelegate: UINavigationControllerDelegate {
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        if let controller = viewController as? UINavigationController {
            controller.delegate = self
        }
    }
    
}

