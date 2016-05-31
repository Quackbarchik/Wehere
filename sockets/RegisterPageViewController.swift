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
    @IBOutlet weak var signupButton: UIButton!

    var token : String = ""
    
    //--------------------------

    override func viewDidLoad() {
        
        super.viewDidLoad()
        tabBarController?.tabBar.hidden = false
        
        signupButton.layer.cornerRadius = 10
        signupButton.layer.borderWidth = 1
        signupButton.layer.borderColor = UIColor.whiteColor().CGColor

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func registerButton(sender: AnyObject) {
        
        let userEmail = userEmailTextFiled.text
        let userPassword = userPasswordTextFiled.text
        let userRepeatPassword = repeatPasswordTextFiled.text
        let userName = userNameTextField.text
        let error : NSInteger 
        
        if (userEmail!.isEmpty || userPassword!.isEmpty || userRepeatPassword!.isEmpty) {
            displayAlert("Все поля обязательны для заполнения")
            return
        }
        
        if (userPassword != userRepeatPassword){
            displayAlert("Пароли не совпадают")
            return
        }
       
        let myUrl = NSURL(string: "http://176.56.50.175:8080/core/api/signup/")
        let params : [String:String] = ["username" : userEmail!,"password1": userPassword!,"password2": userRepeatPassword!,"name": userName!]
        
        Alamofire.request(.POST, myUrl!, parameters: params).responseJSON { response in

            let json = JSON(response.result.value!)
            print(json)
            if let getToken = json["token"].string {
                TokenManager.setToken(getToken)
                let storyb : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc : ViewController = storyb.instantiateViewControllerWithIdentifier("mapViewID") as! ViewController
                self.presentViewController(vc, animated: true, completion: nil)
                
            }else if let error = json["data"]["code"].int {
                if (error == 1){
                    self.displayAlert("Пользователь уже существует")
                }
            }
        }
    }
    
    func displayAlert(userMessage:String){
        let myAlert = UIAlertController(title: "Предупреждение", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "ОК", style: .Default, handler: nil)
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
    }

    @IBAction func accReadyGoToLogin(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}