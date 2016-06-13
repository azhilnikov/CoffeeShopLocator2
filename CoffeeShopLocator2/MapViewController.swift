//
//  MapViewController.swift
//  CoffeeShopLocator2
//
//  Created by Alexey on 2/06/2016.
//  Copyright © 2016 Alexey Zhilnikov. All rights reserved.
//

import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak private var mapView: MKMapView!
    
    var coffeeShop: CoffeeShop!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        mapView.showsUserLocation = true
        
        // Show shop location and region 1000x1000m
        let region = MKCoordinateRegionMakeWithDistance(coffeeShop.coordinate, 1000, 1000)
        mapView.setRegion(region, animated: true)
        
        // Show shop on the map
        let shopAnnotation = MKPointAnnotation()
        shopAnnotation.coordinate = coffeeShop.coordinate
        shopAnnotation.title = coffeeShop.address
        mapView.addAnnotation(shopAnnotation)
        mapView.selectAnnotation(shopAnnotation, animated: true)
        
        // Navigation title
        navigationItem.title = coffeeShop.name
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
