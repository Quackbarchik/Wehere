//
//  ConnectSockets.swift
//  sockets
//
//  Created by Zakhar Rudenko on 30.03.16.
//  Copyright © 2016 Zakhar Rudenko. All rights reserved.
//

import SwiftWebSocket
import SwiftyJSON
import MapKit
import CoreData

class ConnectSockets : UIViewController {
    
    let ws = WebSocket("ws://176.56.50.175:8000/core/socket/new/")
    var codeError = String()
    static var isConnection : Bool = false
    var collectionUser = [UserDataClass]()

    func sendMessage(notification:NSNotification){
        
        if let message = notification.userInfo!["message"]{
                self.ws.send(message)
        }
    }
   
    func connectSockets(){
        
        ws.event.open = {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.sendMessage), name: "socket", object:nil)
            ConnectSockets.isConnection = true
        }
        ws.event.close = { code, reason, clean in
            print("Соединение разорвано")
            ConnectSockets.isConnection = false
        }
        ws.event.message = { message in
            if let text = message as? String {
                self.delegateMethod(text)
            }
        }
    }
    
    func delegateMethod(jsonRaw: String){
        
        if let data = jsonRaw.dataUsingEncoding(NSUTF8StringEncoding) {
            let json = JSON(data:data)
            var method = String()
            method = String(json["method"])
            if(method=="auth"){
            ws.send(TokenManager.getRelation(TokenManager.getToken()))
            }
                else if(method=="list_relation"){
                controllerRelation(jsonRaw)
                }
                    else if(method=="update"){
                    controllerUpdate(jsonRaw)
                    }
        }
    }

    func controllerUpdate(text: String){
    
        var latitude = CLLocationDegrees()
        var longitude = CLLocationDegrees()
        var deviceId = String()
        var link_to_image = String()
        var name = String()
        var user = String()
        
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding){
            let json = JSON(data:data)
                if let long = CLLocationDegrees(String(json["data","longitude"])) {
                    longitude = long
                }
                    if let lat = CLLocationDegrees(String(json["data","latitude"])) {
                        latitude = lat
                    }
                        deviceId = String(json["data","device_ID"])
                        link_to_image = String(json["data","link_to_image"])
                        name = String(json["data","name"])
                        user = String(json["data","user"])
        
                        let dataGood = UserDataClass(latitude:latitude,longitude:longitude,deviceId:deviceId,link_to_image:link_to_image,name:name,user:user)
                        let sendData:[String:AnyObject] = ["Relation":dataGood]
                        NSNotificationCenter.defaultCenter().postNotificationName("update", object:nil,userInfo: sendData)
        }
    }

    func controllerRelation(text: String){
   
        var latitude = CLLocationDegrees()
        var longitude = CLLocationDegrees()
        var deviceId = String()
        var link_to_image = String()
        var name = String()
        var user = String()
        
//        drop()
        
            if let data = text.dataUsingEncoding(NSUTF8StringEncoding){
                let json = JSON(data:data)
                    for res in json["data"].arrayValue{
                        if let long = CLLocationDegrees(String(res["longitude"])) {
                            longitude = long
                        }
                        if let lat = CLLocationDegrees(String(res["latitude"])) {
                            latitude = lat
                        }
                        deviceId = String(res["device_ID"])
                        link_to_image = String(res["link_to_image"])
                        name = String(res["name"])
                        user = String(res["user"])
                        
                        let userPrepare = UserDataClass(latitude: latitude, longitude: longitude, deviceId: deviceId, link_to_image: link_to_image, name: name, user: user)
                        
                        save(latitude, longitude: longitude, deviceId: deviceId, link_to_image: link_to_image, name: name, user: user) //save into DB
                        collectionUser.append(userPrepare) //save into array
                        let sendData:[String:AnyObject] = ["Relation":collectionUser]
                        NSNotificationCenter.defaultCenter().postNotificationName("relation", object:nil,userInfo: sendData)
                    }
            }
    }
    
    func save(latitude:Double,longitude:Double,deviceId:String,link_to_image:String,name:String,user:String){
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity = NSEntityDescription.entityForName("User",inManagedObjectContext: managedContext)
        let options = NSManagedObject(entity: entity!,insertIntoManagedObjectContext:managedContext)
        
        options.setValue(latitude, forKey: "latitude")
        options.setValue(longitude, forKey: "longitude")
        options.setValue(deviceId, forKey: "deviceId")
        options.setValue(link_to_image, forKey: "link_to_image")
        options.setValue(name, forKey: "name")
        options.setValue(user, forKey: "user")
        
            do {
                try managedContext.save()
            } catch{
                print("error")
            }
    }
 
    func drop(){
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let coord = appDelegate.persistentStoreCoordinator
        let fetchRequest = NSFetchRequest(entityName: "User")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
            do {
                try coord.executeRequest(deleteRequest, withContext: managedContext)
            } catch{
                print("error")
            }
    }
}