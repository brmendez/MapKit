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
        let longPress = UILongPressGestureRecognizer(target: self, action: "didLongPressMap:")
        self.mapView.addGestureRecognizer(longPress)
        self.mapView.delegate = self
        self.locationManager.delegate = self
        
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
            self.mapView.addAnnotation(annotation)
            
        }
    }

    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "ANNOTATION")
        annotationView.animatesDrop = true
        annotationView.canShowCallout = true
        let addButton = UIButton.buttonWithType(UIButtonType.ContactAdd) as UIButton
        annotationView.rightCalloutAccessoryView = addButton
        return annotationView
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        let reminderVC = storyboard?.instantiateViewControllerWithIdentifier("REMINDER_VC") as AddReminderViewController
        reminderVC.locationManager = self.locationManager
        reminderVC.selectedAnnotation = view.annotation
        self.presentViewController(reminderVC, animated: true, completion: nil)
    }
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        println("you are inside the region!")
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
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        println("location update")
        
        
        if let location = locations.last as? CLLocation {
            println(location.coordinate.latitude)
        }
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

