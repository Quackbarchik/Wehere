//
//  LoginViewController.swift
//  sockets
//
//  Created by Zakhar Rudenko on 07.05.16.
//  Copyright © 2016 Zakhar Rudenko. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import QuartzCore

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var loginView: UIButton!

    @IBOutlet weak var signupView: UIButton!
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    //--------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userPasswordTextField.delegate = self
        userEmailTextField.delegate = self
        tabBarController?.tabBar.hidden = false
        
        loginView.layer.cornerRadius = 10
        loginView.layer.borderWidth = 1
        loginView.layer.borderColor = UIColor.whiteColor().CGColor
        
        //color SIGN UP
        let colorSIGN = UIColor.init(red: 0, green: 122, blue: 255, alpha: 1)
        signupView.layer.cornerRadius = 10
        signupView.layer.borderWidth = 1
        signupView.layer.borderColor = colorSIGN.CGColor
        
        signupView.setTitleColor(colorSIGN, forState: UIControlState.Normal)
       // 0 122 255
        
    }
    
    override func  viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        userEmailTextField.resignFirstResponder()
        userPasswordTextField.becomeFirstResponder()
        return true
    }
    
    @IBAction func lolginButtonTapped(sender: AnyObject) {
        
        userEmailTextField.returnKeyType = UIReturnKeyType.Next
        
        let userEmail = userEmailTextField.text as String!
        let userPassword = userPasswordTextField.text as String!
        
        if (userEmail!.isEmpty || userPassword!.isEmpty) {
            displayAlert("Все поля обязательны для заполнения")
            return
        }
        self.userEmailTextField.endEditing(true)
        self.userPasswordTextField.endEditing(true)

//        if userPassword {
//            // Проверка на то чтобы не вылетало без кривого пароля, кароч сделать надо так, чтобы сверялся с кодом ошибки, вот
//        }
        
        let myUrl = NSURL(string: "http://176.56.50.175:8080/core/api/get-token/")
        let params = ["username" : userEmail,"password": userPassword]
        
        Alamofire.request(.POST, myUrl!, parameters: params).responseJSON { response in
            
            let token = response.result.value?.valueForKey("token")
            if (ConnectSockets.isConnection){
                if let getToken = token{
                    TokenManager.setToken(getToken as! String)
                    
                    let storyb : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let tabBar : UITabBarController = storyb.instantiateViewControllerWithIdentifier("TabBar") as! UITabBarController
                    let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
                    appDel.window!.rootViewController = tabBar
                }
            }else{
                self.displayAlert("Сервер недоступен")
            }
        }
    }

    func displayAlert(userMessage:String){
        
        let myAlert=UIAlertController(title:"Предупреждение",message:userMessage,preferredStyle:UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
    }
}