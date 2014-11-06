//
//  ReminderTableViewController.swift
//  MapKit
//
//  Created by Brian Mendez on 11/5/14.
//  Copyright (c) 2014 Brian Mendez. All rights reserved.
//

import UIKit
import CoreData

class ReminderTableViewController: UIViewController, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    var managedObjectContext : NSManagedObjectContext!
    var fetchedResultsController : NSFetchedResultsController!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.managedObjectContext = appDelegate.managedObjectContext
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didGetCloudChanges:", name: NSPersistentStoreDidImportUbiquitousContentChangesNotification, object: appDelegate.persistentStoreCoordinator)
        
        self.tableView.dataSource = self
        
        var fetchRequest = NSFetchRequest(entityName: "Reminder")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: "ReminderCache")
        self.fetchedResultsController.delegate = self
        
        var error : NSError?
        var success = self.fetchedResultsController.performFetch(&error)
        if success == false {
            println("Error in Fetch Request: \(error)")
        }
    }
    
    func didGetCloudChanges(notification : NSNotification) {
        println("in did get cloud changes")
        self.managedObjectContext.mergeChangesFromContextDidSaveNotification(notification)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println("number of rows: \(section)")
        println("fetched results \(fetchedResultsController.fetchedObjects)")
        return self.fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        println("in cell for row!")
        let cell = tableView.dequeueReusableCellWithIdentifier("REMINDER_CELL", forIndexPath: indexPath) as UITableViewCell
        let reminder = self.fetchedResultsController.fetchedObjects?[indexPath.row] as Reminder
        cell.textLabel?.text = reminder.name
        return cell
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
