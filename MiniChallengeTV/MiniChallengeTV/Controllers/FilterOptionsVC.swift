//
//  FilterOptionsVC.swift
//  MiniChallengeTV
//
//  Created by Ezequiel de Oliveira Lima on 19/05/16.
//  Copyright © 2016 BEPiD. All rights reserved.
//

import UIKit

enum FilterType {
    case Alphabetic
    , BetterRated
    , LowestPrice
    , BiggestPrice
}

protocol FilterDelegate {
    func filter(by filter: FilterType)
}

class FilterOptionsVC: UITableViewController {
    var delegate: FilterDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let frVC = ((splitViewController as! FilterSplitVC).viewControllers[1] as! UINavigationController).viewControllers[0] as! FilterResultsVC
        self.delegate = frVC
        switch indexPath.row {
        case 0: self.delegate?.filter(by: FilterType.Alphabetic)
        case 1: self.delegate?.filter(by: FilterType.BetterRated)
        case 2: self.delegate?.filter(by: FilterType.LowestPrice)
        case 3: self.delegate?.filter(by: FilterType.BiggestPrice)
        default: break
        }
    }
}
