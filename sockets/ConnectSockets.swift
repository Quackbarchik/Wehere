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

class ConnectSockets : UIViewController {
    
    let ws = WebSocket("ws://176.56.50.175:8000/core/socket/new/")
    var codeError = String()
    static var isConnection :Bool = false

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
            print(1488)
            if let text = message as? String {
                self.delegateMethod(text)
                //Здесь приходит ответ в JSON'е, который потом отправляется путешесвтовать в конверт и уже от туда выдергивается код ошибки. РАУНД.
            }
        }
    }
    
//    func coconvertJSON(text:String) ->Bool{
//        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
//            let json = JSON(data:data)
//            codeError = String(json["data"]["code"])
//            
//            if codeError == "666" {
//                return true
//            }else if codeError == "66"{
//                print("Code = 66")
//            }
//        }
//    return false
//    }
    
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
    }

func controllerUpdate(text: String){
    var IMEI = String()
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
        IMEI =  String(json["data"]["IMEI"])
        deviceId = String(json["data","device_ID"])
        link_to_image = String(json["data","link_to_image"])
        name = String(json["data","name"])
        user = String(json["data","user"])
        
        var dataGood = UserDataClass(IMEI:IMEI,latitude:latitude,longitude:longitude,deviceId:deviceId,link_to_image:link_to_image,name:name,user:user)
        let sendData:[String:AnyObject] = ["Relation":dataGood]
        NSNotificationCenter.defaultCenter().postNotificationName("update", object:nil,userInfo: sendData)
    }
}

    func controllerRelation(text: String){
       
        var withoutDump  = text.stringByReplacingOccurrencesOfString("[\\[\\]]", withString: "", options: .RegularExpressionSearch)
        
        var IMEI = String()
        var latitude = CLLocationDegrees()
        var longitude = CLLocationDegrees()
        var deviceId = String()
        var link_to_image = String()
        var name = String()
        var user = String()
        
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding){
            let json = JSON(data:data)
            
            var collectionUser = [UserDataClass]()
            
            for res in json["data"].arrayValue{
                print(res)
                if let long = CLLocationDegrees(String(res["longitude"])) {
                    longitude = long
                }
                if let lat = CLLocationDegrees(String(res["latitude"])) {
                    latitude = lat
                }
                IMEI =  String(res["IMEI"])
                deviceId = String(res["device_ID"])
                link_to_image = String(res["link_to_image"])
                name = String(res["name"])
                user = String(res["user"])
                
                let userPrepare = UserDataClass(IMEI: IMEI, latitude: latitude, longitude: longitude, deviceId: deviceId, link_to_image: link_to_image, name: name, user: user)
                
                collectionUser.append(userPrepare)
            }
            
            
            print(collectionUser.count)
           
            let sendData:[String:AnyObject] = ["Relation":collectionUser]
            NSNotificationCenter.defaultCenter().postNotificationName("relation", object:nil,userInfo: sendData)
        }
}