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
    @IBOutlet weak var mapView: MKMapView!

    @IBAction func button(sender: AnyObject) {ConnectSockets().connectSockets()}
    @IBAction func exitButton(sender: AnyObject) {
        
    }
    
    //--------------------------

    
    override func viewDidLoad() {
        
       // var loca = CLLocationCoordinate2DMake()
//print(loca)
//        var span = MKCoordinateSpanMake(0.02, 0.02)
//        var region = MKCoordinateRegion(center: loca, span: span)
//        
//        mapView.setRegion(region, animated: true)
//        
//        var annotation = MKPointAnnotation()
//        annotation.coordinate = loca
//        annotation.title = "Tittle"
//        annotation.subtitle = "Sub"
//        
//        mapView.addAnnotation(annotation)
        
        
        
    super.viewDidLoad()
        
    
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(setImageViewRed), name: "relation", object:nil)
    }
    
    func setImageViewRed(ns:NSNotification) {
        
        let arr = ns.userInfo!["Relation"] as! UserDataClass
        var location = CLLocationCoordinate2DMake(arr.latitude!, arr.longitude!)
        var span = MKCoordinateSpanMake(0.02, 0.02)
        var region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        var annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = arr.name
        annotation.subtitle = arr.user
        mapView.addAnnotation(annotation)
    }

    override func viewDidAppear(animated: Bool) {
        self.shouldPerformSegueWithIdentifier("loginView", sender: self)
    }
    
    //MARK: 3D TOUCH
    enum Shortcut: String {
        case openBlue = "Connect"
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