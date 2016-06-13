//
//  CoffeeShopCell.swift
//  CoffeeShopLocator2
//
//  Created by Alexey on 13/06/2016.
//  Copyright © 2016 Alexey Zhilnikov. All rights reserved.
//

import UIKit

class CoffeeShopCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var phoneNumberButton: UIButton!
    
    var phoneButtonTapHandler = { () -> Void in }
    
    @IBAction func phoneNumberButtonTapped(sender: UIButton) {
        phoneButtonTapHandler()
    }
}
