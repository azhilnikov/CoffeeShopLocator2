//
//  CoffeeShopStore.swift
//  CoffeeShopLocator2
//
//  Created by Alexey on 13/06/2016.
//  Copyright © 2016 Alexey Zhilnikov. All rights reserved.
//

import Foundation
import CoreLocation
import Alamofire
import SwiftyJSON

protocol CoffeeShopStoreDelegate {
    func didUpdateCoffeeShopStore()
    func didPhoneNumberTapped(phoneNumber: String)
}

class CoffeeShopStore: NSObject, CLLocationManagerDelegate {
    
    var searchRadius = 0 {
        didSet {
            if let location = currentLocation {
                stopTimer()
                // Get a list of coffee shops if radius is changed and location is known
                fetchShopsWithin(searchRadius, location: location)
                startTimer()
            }
        }
    }
    
    var delegate: CoffeeShopStoreDelegate?
    
    private var allShops = [CoffeeShop]()
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocationCoordinate2D?
    private weak var timer = NSTimer()
    
    subscript(index: Int) -> CoffeeShop {
        return allShops[index]
    }
    
    override init() {
        super.init()
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    deinit {
        stopTimer()
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: - Location manager delegate
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = manager.location?.coordinate {
            if nil == currentLocation {
                fetchShopsWithin(searchRadius, location: location)
                startTimer()
            }
            currentLocation = location
        }
    }
    
    // MARK: - Private methods
    
    private func fetchShopsWithin(radius: Int, location: CLLocationCoordinate2D) {
        
        let parameters = [
            "client_id": "ACAO2JPKM1MXHQJCK45IIFKRFR2ZVL0QASMCBCG5NPJQWF2G",
            "client_secret": "YZCKUYJ1WHUV2QICBXUBEILZI1DMPUIDP5SHV043O04FKBHL",
            "v": "20130815",
            "section": "coffee",
            "radius": String(radius),
            "openNow": "1",
            "sortByDistance": "1",
            "ll": String(location.latitude) + "," + String(location.longitude)]
        
        Alamofire.request(.GET, "https://api.foursquare.com/v2/venues/explore", parameters: parameters)
            .validate()
            .responseJSON { [unowned self] response in
                
                switch response.result {
                case .Success:
                    // Remove old shops
                    self.allShops.removeAll()
                    
                    if let value = response.result.value {
                        // Parse JSON data
                        let json = JSON(value)
                        
                        // Array with coffee shops
                        let items = json["response"]["groups"][0]["items"]
                        
                        for (_, subJson): (String, JSON) in items {
                            let venue = subJson["venue"]
                            let shop = CoffeeShop(json: venue)
                            self.allShops.append(shop)
                        }
                        
                        // Update table view
                        self.delegate?.didUpdateCoffeeShopStore()
                    }
                    
                case .Failure(let error):
                    print(error)
                }
        }
    }
    
    @objc private func locationTimeout() {
        fetchShopsWithin(searchRadius, location: currentLocation!)
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func startTimer() {
        timer = NSTimer.scheduledTimerWithTimeInterval(15,
                                                       target: self,
                                                       selector: #selector(locationTimeout),
                                                       userInfo: nil,
                                                       repeats: true)
    }
}

extension CoffeeShopStore: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allShops.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CoffeeShopCell", forIndexPath: indexPath) as! CoffeeShopCell
        
        let shop = allShops[indexPath.row]
        
        cell.nameLabel.text = shop.name
        cell.distanceLabel.text = String(shop.distance) + "m"
        
        // Hide phone button if phone number is unknown
        cell.phoneNumberButton.hidden = shop.phoneNumber.isEmpty
        cell.phoneNumberButton.setTitle(shop.phoneNumber, forState: .Normal)
        cell.phoneButtonTapHandler = {
            if !shop.phoneNumber.isEmpty {
                self.delegate?.didPhoneNumberTapped(shop.phoneNumber)
            }
        }
        return cell
    }
}
