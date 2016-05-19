//
//  ChildrenAdd.swift
//  sockets
//
//  Created by Zakhar Rudenko on 17.05.16.
//  Copyright © 2016 Zakhar Rudenko. All rights reserved.
//

import UIKit
import CoreData


class childrenAdd: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var children = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Family"
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell
        cell.textLabel!.text = children[indexPath.row]
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return children.count
    }
    
    @IBAction func addChildren(sender: AnyObject) {
        let alert = UIAlertController(title: "New child",message: "Add a new child",preferredStyle: .Alert)
        let saveAction = UIAlertAction(title: "Save",style: .Default) { (action: UIAlertAction!) -> Void in
            
                                        let textField = alert.textFields![0]
                                        self.children.append(textField.text!)
                                        let texts = alert.textFields![1]
                                        self.children.append(texts.text!)
                                        self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",style: .Default) { (action: UIAlertAction!) -> Void in}
        
        alert.addTextFieldWithConfigurationHandler {(textField: UITextField!) -> Void in}
        alert.addTextFieldWithConfigurationHandler {(texts: UITextField!) -> Void in}
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        presentViewController(alert,animated: true,completion: nil)
    }
}