//
//  ContactsRepository.swift
//  ContactVieweriOs
//
//  Created by Ryan Trosvig on 4/15/15.
//  Copyright (c) 2015 Ryan Trosvig. All rights reserved.
//

// SAVE DATA TO NSJSONSerialization (Native JSON framework)

//        objects.insertObject(NSDate(), atIndex: 0)
//        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
//        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)

import Foundation

class ContactsRepository : NSObject
{
    var contacts = [Contact]()
    
    class var sharedInstance: ContactsRepository {
        struct Static {
            static let instance: ContactsRepository = ContactsRepository()
        }
        return Static.instance
    }
    

    
    override init()
    {
        //Create intial dumby list of contacts
        //contacts.append(Contact(name: "a", phone: "123", title: "dude", email: "a@a.com", twitterId: "aman"))
        //contacts.append(Contact(name: "b", phone: "456", title: "dudette", email: "b@b.com", twitterId: "bgirl"))
        //contacts.append(Contact(name: "c", phone: "789", title: "dudelet", email: "c@c.com", twitterId: "ckid"))
        //let url = NSURL(string:"http://contacts.tinyapollo.com/contacts?key=grumpy")!
        //var request = NSMutableURLRequest(URL: url)
        //request.HTTPMethod = "GET"
        //let session = NSURLSession.sharedSession()
        //let task = session.dataTaskWithRequest(request, completionHandler:{data, response, error ->
        //    Void in
            // deserialize the response
        //    var err: NSError?
        //    let responseDict = NSJSONSerialization.JSONObjectWithData(data, options:.MutableLeaves,
        //        error:&err) as NSDictionary
            
        //    ContactsRepository.sharedInstance.loadInstance(responseDict)
            
        //})
        //task.resume()
        contacts.removeAll(keepCapacity: false)

    }

    func loadInstance(iContacts: NSDictionary) {
        let cArray: [NSDictionary] = iContacts["contacts"] as [NSDictionary]
        contacts.removeAll(keepCapacity: false)
        for cInfo in cArray {
            contacts.append(Contact(name: cInfo["name"] as String, phone: cInfo["phone"] as String, title: cInfo["title"] as String, email: cInfo["email"] as String, twitterId: cInfo["twitterId"] as String, _id: cInfo["_id"] as String))
            self.UpdateIndices()
        }
    }
    
    func GetContacts() -> [Contact] {
        // Update from repository first
        self.UpdateIndices();
        return contacts
    }
    
    func UpdateExistingContact(contactObj:Contact, mId:Int)
    {
        contacts.removeAtIndex(mId)
        contacts.insert(contactObj, atIndex: mId)
        var param :Dictionary<String, String> = ["name":contactObj.name,"title":contactObj.title, "phone":contactObj.phone, "email":contactObj.email,"twitterId":contactObj.email]
        
        jsonSessionPut(contactObj._id, param: param)
        NSLog("Updated contact %d, total %d", mId, self.contacts.count)
    }
    
    func AddNewContact(contactObj:Contact)
    {
        contacts.append(contactObj)
        self.UpdateIndices()
        var param :Dictionary<String, String> = ["name":contactObj.name,"title":contactObj.title, "phone":contactObj.phone, "email":contactObj.email,"twitterId":contactObj.email]

        jsonSessionPost(param)
        NSLog("Added new contact total %d", self.contacts.count)
    }
    
    func DeleteContact(mId:Int)
    {
        let contactObj:Contact = contacts[mId]
        contacts.removeAtIndex(mId)
        self.UpdateIndices()
        var param :Dictionary<String, String> = ["name":contactObj.name,"title":contactObj.title, "phone":contactObj.phone, "email":contactObj.email,"twitterId":contactObj.email]
        
        jsonSessionDelete(contactObj._id, param:param)
        NSLog("Deleted contact %d, total %d", mId, self.contacts.count)
    }
    
    func UpdateIndices()
    {
        for var i = 0; i < contacts.count; i++
        {
            contacts[i].setMyIndex(i)
        }
    }
    
    func jsonSessionPut(id:String, param:Dictionary<String, String>)
    {
        
        let putURL :String = "http://contacts.tinyapollo.com/contacts/\(id)?key=grumpy"

        let url = NSURL(string:putURL)!
        var request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "PUT"
        
        var err: NSError?
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(param, options: nil, error: &err)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let session = NSURLSession.sharedSession()
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
      
        //deserialize the response
        let responseDict = NSJSONSerialization.JSONObjectWithData(data, options:.MutableLeaves,
            error:&err) as NSDictionary
        
        //ContactsRepository.sharedInstance.loadInstance(responseDict)
        
        })
        task.resume()
    

    }
 
    func jsonSessionPost(param:Dictionary<String, String>)
    {
        
        let postURL :String = "http://contacts.tinyapollo.com/contacts?key=grumpy"
        
        let url = NSURL(string:postURL)!
        var request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        
        var err: NSError?
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(param, options: nil, error: &err)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let session = NSURLSession.sharedSession()
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            
            //deserialize the response
            let responseDict = NSJSONSerialization.JSONObjectWithData(data, options:.MutableLeaves,
                error:&err) as NSDictionary
            
            //ContactsRepository.sharedInstance.loadInstance(responseDict)
            
        })
        task.resume()
        
        
    }

    func jsonSessionDelete(id: String, param:Dictionary<String, String>)
    {
        
        let delURL :String = "http://contacts.tinyapollo.com/contacts/\(id)?key=grumpy"
        
        let url = NSURL(string:delURL)!
        var request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "DELETE"
        
        var err: NSError?
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(param, options: nil, error: &err)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let session = NSURLSession.sharedSession()
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            
            //deserialize the response
            let responseDict = NSJSONSerialization.JSONObjectWithData(data, options:.MutableLeaves,
                error:&err) as NSDictionary
            
            //ContactsRepository.sharedInstance.loadInstance(responseDict)
            
        })
        task.resume()
        
        
    }

    // Use this to access the local persistent storage
    //let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .
    //    UserDomainMask, true)[0] as NSString
    //let path = NSBundle.mainBundle().pathForResource("filename", ofType: "fileExt")
}