//
//  DetailViewController.swift
//  ContactVieweriOs
//
//  Created by Ryan Trosvig on 4/11/15.
//  Copyright (c) 2015 Ryan Trosvig. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var twitterLabel: UILabel!
    @IBOutlet weak var newlabel: UILabel!

    var index: Int = -1
    
    var detailItem: Contact? {
        didSet {
            // Update the view.
            //self.configureView()
        }
    }

    var contactIndex: Int? {
        didSet {
            //self.index = self.contactIndex!
        }
    }
    
    func configureView() {
        if let mIndex: Int = self.contactIndex{
            self.index = mIndex
        }
        // Update the user interface for the detail item.
        //self.nameLabel.text = self.detailItem?.name
        if let mContact: Contact = self.detailItem {
            if let label = self.nameLabel {
                label.text = mContact.name
            }
            if let label = self.phoneLabel {
                label.text = mContact.phone
            }
            if let label = self.titleLabel {
                label.text = mContact.title
            }
            if let label = self.emailLabel {
                label.text = mContact.email
            }
            if let label = self.twitterLabel {
                label.text = mContact.twitterId
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let controller = (segue.destinationViewController as UINavigationController).topViewController as EditViewController
        if let mContact: Contact = self.detailItem{
            controller.editItem = mContact
        }
        controller.contactIndex = self.index
        controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
        controller.navigationItem.leftItemsSupplementBackButton = true
    }
    
    @IBAction func EditButtonPressed(sender: UIButton) {
        //let ctrl = EditViewController(nibName:  "EditViewController", bundle: nil)
        //self.navigationController?.pushViewController(ctrl, animated: true)
    }
    
    
}

