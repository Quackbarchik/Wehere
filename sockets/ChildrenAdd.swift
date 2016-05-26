//
//  ChildrenAdd.swift
//  sockets
//
//  Created by Zakhar Rudenko on 17.05.16.
//  Copyright © 2016 Zakhar Rudenko. All rights reserved.
//

import UIKit
import CoreData


class childrenAdd: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var repeatPassField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.nameField.isEqual(self.loginField){
            self.loginField.becomeFirstResponder()
        }
    }
    
    @IBAction func registration(sender: AnyObject) {
    }
}