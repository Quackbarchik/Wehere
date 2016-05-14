//
//  RegisterPageViewController.swift
//  sockets
//
//  Created by Zakhar Rudenko on 06.05.16.
//  Copyright © 2016 Zakhar Rudenko. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire


class RegisterPageViewController: UIViewController {

    @IBOutlet weak var userEmailTextFiled: UITextField!
    @IBOutlet weak var userPasswordTextFiled: UITextField!
    @IBOutlet weak var repeatPasswordTextFiled: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    
    var token : String = ""
    
    //--------------------------

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerButton(sender: AnyObject) {
        
        let userEmail = userEmailTextFiled.text
        let userPassword = userPasswordTextFiled.text
        let userRepeatPassword = repeatPasswordTextFiled.text
        let userName = userNameTextField.text
        
        if (userEmail!.isEmpty || userPassword!.isEmpty || userRepeatPassword!.isEmpty) {
            
            displayAlert("All fields are required")
            return
        }
        
        if (userPassword != userRepeatPassword)
        {
            displayAlert("Passwords do not match")
            return
        }
       
        let myUrl = NSURL(string: "http://176.56.50.175:8080/core/api/signup/")
        
        let params : [String:String] = ["username" : userEmail!,"password1": userPassword!,"password2": userRepeatPassword!,"name": userName!]
        
        Alamofire.request(.POST, myUrl!, parameters: params).responseJSON { response in
                debugPrint(response.result)
            
            let json = JSON(response.result.value!)
            
            if let getToken = json["token"].string {
                self.token = getToken
                
               TokenManager.mainToken = self.token              
            }
        }

        var myAlert = UIAlertController(title: "Alert", message: "Registration is sucessful. Good job!", preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default){action in self.dismissViewControllerAnimated(true, completion: nil)}
        
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
        
    }
    
    
    func displayAlert(userMessage:String){
        
        var myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        var okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        myAlert.addAction(okAction)
        
        self.presentViewController(myAlert, animated: true, completion: nil)
    }

    @IBAction func accReadyGoToLogin(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
