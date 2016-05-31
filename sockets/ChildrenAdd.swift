//
//  ChildrenAdd.swift
//  sockets
//
//  Created by Zakhar Rudenko on 17.05.16.
//  Copyright © 2016 Zakhar Rudenko. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import SwiftyJSON


class childrenAdd: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var repeatPassField: UITextField!
    
    @IBOutlet weak var regisChild: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        regisChild.layer.cornerRadius = 10
        regisChild.layer.borderWidth = 1
        regisChild.layer.borderColor = UIColor.whiteColor().CGColor

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func registration(sender: AnyObject) {
        
        let name = nameField.text
        let login = loginField.text
        let pass = passField.text
        let repeatPass = repeatPassField.text
        
        if (name?.isEmpty)! || (login?.isEmpty)! || (pass?.isEmpty)! || (repeatPass?.isEmpty)! {
            displayAlert("All fields are required")
            return
        }
        if (pass != repeatPass) {
            displayAlert("Passwords do not match")
            return
        }
        
        let myUrl = NSURL(string: "http://176.56.50.175:8080/core/api/add/child/")
        let params : [String:String] = ["name_child":name!,"login_child":login!,"password1":pass!,"password2":repeatPass!]
        let headers = ["Authorization":"Token \(TokenManager.getToken())"]
        Alamofire.request(.POST, myUrl!, parameters: params, headers: headers).responseJSON{ response in
            debugPrint(response)
            let json = JSON(response.result.value!)
            print(json)
            
        }

    }
    
    func displayAlert(userMessage:String){
        let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
    }
    
}