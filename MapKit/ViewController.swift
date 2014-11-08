//
//  ViewController.swift
//  MapKit
//
//  Created by Brian Mendez on 11/3/14.
//  Copyright (c) 2014 Brian Mendez. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reminderAdded:", name: "REMINDER_ADDED", object: nil) //will get any notification with name: perameter. Nil gives EVERY post, we don't want that. Also make sure to UNREGISTER
        
        let longPress = UILongPressGestureRecognizer(target: self, action: "didLongPressMap:")
        self.mapView.addGestureRecognizer(longPress)
        self.locationManager.delegate = self
        self.mapView.delegate = self
        
        switch CLLocationManager.authorizationStatus() as CLAuthorizationStatus {
        case .Authorized:
            println("authorized")
            self.mapView.showsUserLocation = true
        case .NotDetermined:
            println("not determined")
            self.locationManager.requestAlwaysAuthorization()
        case .Restricted:
            println("restricted")
        case .Denied:
            println("denied")
        default:
            println("default")
        }
    }
    
    func didLongPressMap(sender: UILongPressGestureRecognizer) {
        
        if sender.state == UIGestureRecognizerState.Began {
            let touchPoint = sender.locationInView(self.mapView)
            let touchCoordinate = self.mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView)
            var annotation = MKPointAnnotation()
            annotation.coordinate = touchCoordinate
            annotation.title = "Add Reminder"
            self.mapView.addAnnotation(annotation) //drops the pin
            println(touchCoordinate.latitude)
            println("long: \(touchCoordinate.longitude)")
        }
    }
    
    //unregister
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "ANNOTATION")
        annotationView.animatesDrop = true
        annotationView.canShowCallout = true //shows popup info bubble
        let addButton = UIButton.buttonWithType(UIButtonType.ContactAdd) as UIButton
        annotationView.rightCalloutAccessoryView = addButton //adds the plus button to the right
        return annotationView
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        let reminderVC = storyboard?.instantiateViewControllerWithIdentifier("REMINDER_VC") as AddReminderViewController
        reminderVC.locationManager = self.locationManager
        reminderVC.selectedAnnotation = view.annotation
        self.presentViewController(reminderVC, animated: true, completion: nil)
    }
    
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        let renderer = MKCircleRenderer(overlay: overlay)
        
        renderer.fillColor = UIColor.purpleColor().colorWithAlphaComponent(0.20)
        renderer.strokeColor = UIColor.blueColor()
        renderer.lineWidth = 0.5
        
        return renderer
    }
    
//    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
//        let renderer = MKCircleRenderer(overlay: overlay)
//        renderer.fillColor = UIColor.purpleColor().colorWithAlphaComponent(0.20)
////        renderer.strokeColor = UIColor.blackColor()
////        renderer.strokePath(<#path: CGPath!#>, inContext: <#CGContext!#>)
//        return renderer
//        
//    }
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        println("you are inside the region!")
        if let circularRegion = region as? CLCircularRegion {
            println("lat: \(circularRegion.center.latitude)")
            println("long: \(circularRegion.center.longitude)")
            if (UIApplication.sharedApplication().applicationState == UIApplicationState.Background) {
                var notification = UILocalNotification()
                notification.alertAction = "Enter region!"
                notification.alertBody = "You have entered the region!"
                notification.fireDate = NSDate()
                UIApplication.sharedApplication().scheduleLocalNotification(notification)
            }
        }
    
    }
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        println("you are outside the region!")
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .Authorized:
            println("Authorized")
        default:
            println("Default Authorization Change")
        }
    }
    
    func reminderAdded(notification : NSNotification) {
        println("reminder added!")
        
        let userInfo = notification.userInfo!
        let geoRegion = userInfo["region"] as CLCircularRegion
        
        let overlay = MKCircle(centerCoordinate: geoRegion.center, radius: geoRegion.radius)
        self.mapView.addOverlay(overlay)

    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        println("location update")
        
        
        var lastLocation = locations.last as CLLocation
        let interval = lastLocation.timestamp.timeIntervalSinceNow
            if interval < 20 {
            println(lastLocation.coordinate.latitude)
        }
    }
    
}