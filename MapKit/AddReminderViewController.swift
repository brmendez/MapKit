//
//  AddReminderViewController.swift
//  MapKit
//
//  Created by Brian Mendez on 11/3/14.
//  Copyright (c) 2014 Brian Mendez. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class AddReminderViewController: UIViewController {

    var locationManager : CLLocationManager!
    var selectedAnnotation : MKAnnotation!
    var managedObjectContext : NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.managedObjectContext = appDelegate.managedObjectContext
        
        
//        let regionSet = self.locationManager!.monitoredRegions
//        let regions = regionSet.allObjects

    }
    
    
    @IBAction func didPressAddReminderButton(sender: AnyObject) {
        
        var geoRegion = CLCircularRegion(center: selectedAnnotation.coordinate, radius: 1500.0, identifier: "TestRegion")
        self.locationManager.startMonitoringForRegion(geoRegion)
        
        
        var newReminder = NSEntityDescription.insertNewObjectForEntityForName("Reminder", inManagedObjectContext: self.managedObjectContext) as Reminder
        newReminder.name = geoRegion.identifier
        newReminder.radius = geoRegion.radius
        newReminder.date = NSDate()
        println("radius: \(geoRegion.radius)")
        
        
        
        var error : NSError?
        self.managedObjectContext.save(&error)
        
        //error checking
        if error != nil {
            println(error?.localizedDescription)
        }
        NSNotificationCenter.defaultCenter().postNotificationName("REMINDER_ADDED", object: self, userInfo: ["region" : geoRegion]) //communicates to VC that a reminder was added
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
