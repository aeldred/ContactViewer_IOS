//
//  MasterViewController.swift
//  ContactVieweriOs
//
//  Created by Ryan Trosvig on 4/11/15.
//  Copyright (c) 2015 Ryan Trosvig. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var contacts = ContactsRepository.sharedInstance.GetContacts()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.tableView.reloadData()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

        //let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        //self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = controllers[controllers.count-1].topViewController as? DetailViewController
        }
    }

    override func viewDidAppear(animated: Bool) {
        self.getAllContacts()
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let object = contacts[indexPath.row] as Contact
                let controller = (segue.destinationViewController as UINavigationController).topViewController as DetailViewController
                controller.detailItem = object
                controller.contactIndex = indexPath.row
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
        if segue.identifier == "showEdit" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let object = Contact(name: "", phone: "", title: "", email: "", twitterId: "", _id: "") as Contact
                let controller = (segue.destinationViewController as UINavigationController).topViewController as EditViewController
                controller.editItem = object
                controller.contactIndex = -2
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

        contacts = ContactsRepository.sharedInstance.GetContacts()
        //self.tableView.reloadData()
        let object = contacts[indexPath.row] as Contact
        cell.textLabel!.text = object.name
        // Hack to avoid making a custon cell
        cell.detailTextLabel!.text = "\(object.phone)   \(object.title)"
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            ContactsRepository.sharedInstance.DeleteContact(indexPath.row)
            //self.tableView.reloadData()
            contacts.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    func getAllContacts() -> Void {
        let url = NSURL(string:"http://contacts.tinyapollo.com/contacts?key=grumpy")!
        var request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        let session = NSURLSession.sharedSession()
        NSLog("getAllContacts")
        let task = session.dataTaskWithRequest(request, completionHandler:{data, response, error ->
            Void in
            // deserialize the response
            var err: NSError?
            let responseDict = NSJSONSerialization.JSONObjectWithData(data, options:.MutableLeaves,
                error:&err) as NSDictionary
            
            ContactsRepository.sharedInstance.loadInstance(responseDict)
            
            
            NSOperationQueue.mainQueue().addOperationWithBlock {
                // refresh UI in main thread
                self.contacts = ContactsRepository.sharedInstance.GetContacts()
                self.tableView.reloadData()
            }
            
        })
        task.resume()
    }
}

