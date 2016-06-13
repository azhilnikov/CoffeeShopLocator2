//
//  CoffeeShopViewController.swift
//  CoffeeShopLocator2
//
//  Created by Alexey on 13/06/2016.
//  Copyright © 2016 Alexey Zhilnikov. All rights reserved.
//

import UIKit
import CoreLocation

class CoffeeShopViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var distanceSlider: UISlider!
    @IBOutlet weak private var distanceLabel: UILabel!
    
    private let coffeeShopStore = CoffeeShopStore()
    
    private var searchRadius = 0 {
        didSet {
            distanceLabel.text = "In the radius of " + String(searchRadius) + " meters"
            coffeeShopStore.searchRadius = searchRadius
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchRadius = Int(distanceSlider.value)
        coffeeShopStore.delegate = self
        tableView.dataSource = coffeeShopStore
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if "ShowCoffeeShopLocation" == segue.identifier {
            if let row = tableView.indexPathForSelectedRow?.row {
                
                let shop = coffeeShopStore[row]
                let mapViewController = segue.destinationViewController as! MapViewController
                mapViewController.coffeeShop = shop
            }
        }
    }
    
    // MARK: - Table view delegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    // MARK: - Action
    
    @IBAction func distanceSliderChangedValue(sender: UISlider) {
        searchRadius = Int(sender.value)
    }
}

extension CoffeeShopViewController: CoffeeShopStoreDelegate {
    func didUpdateCoffeeShopStore() {
        // Update table
        tableView.reloadData()
    }
    
    func didPhoneNumberTapped(phoneNumber: String) {
        let alertTitle = "Call " + phoneNumber + " ?"
        
        // Confirm call the shop
        let alert = UIAlertController(title: alertTitle,
                                      message: nil,
                                      preferredStyle: .ActionSheet)
        
        alert.addAction(UIAlertAction(
            title: "OK",
            style: UIAlertActionStyle.Default,
            handler: {(alert: UIAlertAction!) in
                let phoneNumberURL = NSURL(string: "tel://" + phoneNumber)
                UIApplication.sharedApplication().openURL(phoneNumberURL!)
        }))
        
        alert.addAction(UIAlertAction(
            title: "Cancel",
            style: UIAlertActionStyle.Destructive ,
            handler: nil))
        
        presentViewController(alert, animated: true, completion: nil)
    }
}
