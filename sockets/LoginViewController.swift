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

class LoginViewController: UIViewController {

    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
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
    
    @IBAction func lolginButtonTapped(sender: AnyObject) {
        let userEmail = userEmailTextField.text as String!
        let userPassword = userPasswordTextField.text as String!
        
        
        if (userEmail!.isEmpty || userPassword!.isEmpty) {
            
            displayAlert("All fields are required")
            return
        }
//        if userPassword {
//            // Проверка на то чтобы не вылетало без кривого пароля, кароч сделать надо так, чтобы сверялся с кодом ошибки, вот
//        }
        
        let myUrl = NSURL(string: "http://176.56.50.175:8080/core/api/get-token/")
        
        let params = ["username" : userEmail,"password": userPassword]
        
        Alamofire.request(.POST, myUrl!, parameters: params).responseJSON { response in
            debugPrint(response.result)
            
            var token = response.result.value?.valueForKey("token")
            
            if (ConnectSockets.isConnection){
                
                if let getToken = token{
                    print(getToken)
                    
                    TokenManager.setToken(getToken as! String)
                    
                    let sendData:[String:AnyObject] = ["message":"\(TokenManager.getAuth(getToken as! String))"]
                    NSNotificationCenter.defaultCenter().postNotificationName("socket", object:nil,userInfo: sendData)
                }
                
                
            }else{
                print("PUTIN")
            }
            
        
            
            
//            if let json = JSON(response.result.value) {
//                self.token = json["token"].string
//                TokenManager.mainToken = self.token
//            }
          
//            if let getToken = json["token"].string {
//                self.token = getToken
//                
//                TokenManager.mainToken = self.token
//            }
        }
    }
    
    func displayAlert(userMessage:String){
        
        var myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        var okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        myAlert.addAction(okAction)
        
        self.presentViewController(myAlert, animated: true, completion: nil)
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
