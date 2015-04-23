//
//  EditViewController.swift
//  ContactVieweriOs
//
//  Created by Ryan Trosvig on 4/11/15.
//  Copyright (c) 2015 Ryan Trosvig. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {

    @IBOutlet weak var nameBox: UITextField!
    @IBOutlet weak var phoneBox: UITextField!
    @IBOutlet weak var titleBox: UITextField!
    @IBOutlet weak var emailBox: UITextField!
    @IBOutlet weak var twitterBox: UITextField!
    
    var index: Int = -1
    var _id: String = ""
    
    var editItem: Contact? {
        didSet {
        }
    }
    
    var contactIndex: Int? {
        didSet {
            //self.index = self.contactIndex!
        }
    }
    
    func configureView()
    {
        if let mIndex: Int = self.contactIndex{
            self.index = mIndex
            if(mIndex < 0)
            {
                self.nameBox.text = ""
                self.titleBox.text = ""
                self.phoneBox.text = ""
                self.emailBox.text = ""
                self.twitterBox.text = ""
            }
            else
            {
                NSLog("Existing Contact %d", self.index)
                // Update the user interface for the detail item.
                
                if let mContact: Contact = self.editItem
                {
                    if let label = self.nameBox {
                        label.text = mContact.name
                    }
                    if let label = self.phoneBox {
                        label.text = mContact.phone
                    }
                    if let label = self.titleBox {
                    label.text = mContact.title
                        }
                    if let label = self.emailBox {
                        label.text = mContact.email
                    }
                    if let label = self.twitterBox {
                        label.text = mContact.twitterId
                    }
                    _id = mContact._id
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveContact(sender: AnyObject)
    {
        // TODO save the new or updated contact
        if (self.index < 0)
        {
            //Create a new contact
            let mContact = Contact(name: self.nameBox.text,
                phone: self.phoneBox.text, title: self.titleBox.text,
                email: self.emailBox.text, twitterId: self.twitterBox.text, _id: "")
            
            ContactsRepository.sharedInstance.AddNewContact(mContact)
        }
        else
        {
            //Update the existing contact
            let mContact = Contact(name: self.nameBox.text,
                phone: self.phoneBox.text, title: self.titleBox.text,
                email: self.emailBox.text, twitterId: self.twitterBox.text, _id:_id)
            ContactsRepository.sharedInstance.UpdateExistingContact(mContact, mId: self.index)
        }
    }

    
    
    
    
}
