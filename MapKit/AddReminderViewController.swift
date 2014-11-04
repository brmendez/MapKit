//
//  AddReminderViewController.swift
//  MapKit
//
//  Created by Brian Mendez on 11/3/14.
//  Copyright (c) 2014 Brian Mendez. All rights reserved.
//

import UIKit
import MapKit

class AddReminderViewController: UIViewController, CLLocationManagerDelegate {

    var locationManager : CLLocationManager!
    var selectedAnnotation : MKAnnotation!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let regionSet = self.locationManager.monitoredRegions
        let regions = regionSet.allObjects
        
    }
    
    
    @IBAction func didPressAddReminderButton(sender: AnyObject) {
        
        var geoRegion = CLCircularRegion(center: selectedAnnotation.coordinate, radius: 100.0, identifier: "TestRegion")
        self.locationManager.startMonitoringForRegion(geoRegion)
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    

}
