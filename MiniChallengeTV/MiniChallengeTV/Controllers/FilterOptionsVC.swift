//
//  FilterOptionsVC.swift
//  MiniChallengeTV
//
//  Created by Ezequiel de Oliveira Lima on 19/05/16.
//  Copyright © 2016 BEPiD. All rights reserved.
//

import UIKit

class FilterOptionsVC: UITableViewController {
    
    var container: FilterSplitVC?
    var products: List<Product>? {
        didSet {
            self.tableView.selectRowAtIndexPath(nil, animated: true, scrollPosition: UITableViewScrollPosition.None)
        }
    }
    
    private let items:[(SortBy, String)] = [
        (.Alphabetic, "A -> Z")
        , (.DAlphabetic, "Z -> A")
        , (.Rating  , "Pontuação")
        , (.DPrice  , "Preços Menores")
        , (.Price   , "Preços Maiores")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Ordenar Por"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier(.Order) else {
            assert(false)
        }
        let item = items[indexPath.row]
        cell.textLabel?.text = item.1
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = items[indexPath.row]
        container?.sort(by: item.0)
    }
}
