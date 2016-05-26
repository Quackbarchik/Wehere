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
import CoreData


class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    var usersArray = [UserDataClass]()
    var usersAnnotation = [MKPointAnnotation]()
    var isRelation = true
    var locationManager = CLLocationManager()

    @IBOutlet weak var mapView: MKMapView!
    
    //------
    
    func check(){
        if (ConnectSockets.isConnection && isRelation) {
            let sendData:[String:AnyObject] = ["message":"\(TokenManager.getAuth(TokenManager.getToken()))"]
            NSNotificationCenter.defaultCenter().postNotificationName("socket", object:nil,userInfo: sendData)
            isRelation = false
        }else{
            print("not")
        }
    }
    //MARK: LOCATION
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        
        //PRINT
        print("Location: \(newLocation.coordinate.latitude), \(newLocation.coordinate.longitude)")
        
        let device = AppDelegate.UUID //7193E91B-A38D-48EB-920A-9B64A1F5FE8F iphone
        let update = (TokenManager.getUpdate(TokenManager.getToken(), deviceID: device, latitude: newLocation.coordinate.latitude, longitude: newLocation.coordinate.longitude))
        
        let sendData:[String:AnyObject] = ["message":"\(update)"]
        NSNotificationCenter.defaultCenter().postNotificationName("socket", object:nil,userInfo: sendData)
    }
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error from map: ", error.localizedDescription)
    }
    func getLocation(){
        mapView.tintColor = UIColor.init(red: 39, green: 170, blue: 225, alpha: 1)
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        //locationManager.distanceFilter = 1
        mapView.showsUserLocation = true
    
    }
    
    //MARK: ViewDidLoad-------------------------
    override func viewDidLoad() {
        getLocation()

        print("huilo")
        let sendData:[String:AnyObject] = ["message":"\(TokenManager.getAuth(TokenManager.getToken()))"]
        NSNotificationCenter.defaultCenter().postNotificationName("socket", object:nil,userInfo: sendData)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(realation), name: "relation", object:nil)
         NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(update), name: "update", object:nil)
    }
    //MARK: Update and Relation

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
    //MARK: Adding annotations on map
    func inflateUserMaps(){
        mapView.removeAnnotations(usersAnnotation)
        usersAnnotation.removeAll()
        for user in usersArray{
            let location = CLLocationCoordinate2DMake(user.latitude!, user.longitude!)
          //  let span = MKCoordinateSpanMake(20, 20)
       //     let region = MKCoordinateRegion(center: location, span: span)
        //    mapView.setRegion(region, animated: true)
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = user.name
            annotation.subtitle = user.user
            usersAnnotation.append(annotation)
        }
        mapView.addAnnotations(usersAnnotation)
    }
    
    //Заглушка для выхода-------------------------
    func dropMapAndArray(){
        mapView.removeAnnotations(usersAnnotation)
        usersAnnotation.removeAll()
        usersArray.removeAll()
        self.performSegueWithIdentifier("ExitViewID", sender: self)
    }
    //-------------------------
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