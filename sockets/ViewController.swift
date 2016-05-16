//
//  ViewController.swift
//  sockets
//
//  Created by Zakhar Rudenko on 17.03.16.
//  Copyright © 2016 Zakhar Rudenko. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate {
    var usersArray = [UserDataClass]()
    var usersAnnotation = [MKPointAnnotation]()
    
    @IBOutlet weak var mapView: MKMapView!
    @IBAction func exitButton(sender: AnyObject) {
        //dropMapndArray()
        check()
            }
    
    //--------------------------

    func check(){
        if (ConnectSockets.isConnection) {
            let sendData:[String:AnyObject] = ["message":"\(TokenManager.getAuth(TokenManager.getToken()))"]
            NSNotificationCenter.defaultCenter().postNotificationName("socket", object:nil,userInfo: sendData)
            

        }else{
            print("not")
        }
    }
    override func viewDidLoad() {
        
    super.viewDidLoad()
        
        let sendData:[String:AnyObject] = ["message":"\(TokenManager.getAuth(TokenManager.getToken()))"]
        NSNotificationCenter.defaultCenter().postNotificationName("socket", object:nil,userInfo: sendData)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(realation), name: "relation", object:nil)
         NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(update), name: "update", object:nil)        
    }
    
    func update(ns:NSNotification){
        let userUpdate = ns.userInfo!["Relation"] as! UserDataClass
        for user in 0...usersArray.count-1{
           if (usersArray[user].deviceId == userUpdate.deviceId){
                usersArray.removeAtIndex(user)
                usersArray.append(userUpdate)
            }
        }
        inflateUserMaps()
    }

    func realation(ns:NSNotification) {
        let arr = ns.userInfo!["Relation"] as! [UserDataClass]
        usersArray.appendContentsOf(arr)
        inflateUserMaps()
    }
    
    func inflateUserMaps(){
        
        mapView.removeAnnotations(usersAnnotation)
        usersAnnotation.removeAll()
        for user in usersArray{
            var location = CLLocationCoordinate2DMake(user.latitude!, user.longitude!)
            var span = MKCoordinateSpanMake(20, 20)
            var region = MKCoordinateRegion(center: location, span: span)
            mapView.setRegion(region, animated: true)
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = user.name
            annotation.subtitle = user.user
            usersAnnotation.append(annotation)
        }
        mapView.addAnnotations(usersAnnotation)
    }
    
    func dropMapAndArray(){
        mapView.removeAnnotations(usersAnnotation)
        usersAnnotation.removeAll()
        usersArray.removeAll()
        self.performSegueWithIdentifier("ExitViewID", sender: self)
    }

    override func viewDidAppear(animated: Bool) {
        self.shouldPerformSegueWithIdentifier("loginView", sender: self)
    }
    
    //MARK: 3D TOUCH
    enum Shortcut: String {
        case openBlue = "Reg"
    }
    func handleQuickAction(shortcutItem: UIApplicationShortcutItem) -> Bool {
        
        var quickActionHandled = false
        let type = shortcutItem.type.componentsSeparatedByString(".").last!
        if let shortcutType = Shortcut.init(rawValue: type) {
            switch shortcutType {
            case .openBlue:
                ConnectSockets().connectSockets()
                quickActionHandled = true
            }
        }
        return quickActionHandled
    }
}