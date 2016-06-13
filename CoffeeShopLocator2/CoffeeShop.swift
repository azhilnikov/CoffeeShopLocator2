//
//  CoffeeShop.swift
//  CoffeeShopLocator2
//
//  Created by Alexey on 13/06/2016.
//  Copyright © 2016 Alexey Zhilnikov. All rights reserved.
//

//import Foundation
import CoreLocation
import SwiftyJSON

struct CoffeeShop {
    let name: String
    let phoneNumber: String
    let address: String
    let distance: Int
    let coordinate: CLLocationCoordinate2D
    
    init(json: JSON) {
        self.name = json["name"].stringValue
        self.phoneNumber = json["contact"]["phone"].stringValue
        self.address = json["location"]["address"].stringValue
        self.distance = json["location"]["distance"].intValue
        let latitude = json["location"]["lat"].doubleValue
        let longitude = json["location"]["lng"].doubleValue
        self.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
    }
}
