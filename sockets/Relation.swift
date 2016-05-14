//
//  Relation.swift
//  sockets
//
//  Created by Zakhar Rudenko on 30.03.16.
//  Copyright © 2016 Zakhar Rudenko. All rights reserved.
//

import Foundation
import SwiftyJSON
import SwiftWebSocket
import MapKit

class RelationRequest : UIViewController {
    
    let ws = WebSocket("ws://176.56.50.175:8000/core/socket/new/")
  let methodRelation : JSON = ["method":"list_relation","data":["token":"\(TokenManager.mainToken)"]]
 //   let methodRelation : JSON = ["method":"list_relation","data":["token":"4bfe510ac1fbcfc1ca8bc6cb089fa54cdcc2c0f7"]]

    // 3a8d41c7387b36d9b86f7497181a59aa67ea0412

    var convertData = String()
    var method = String()
    
    var IMEI = String()
    var latitude = CLLocationDegrees()
    var longitude = CLLocationDegrees()
    var deviceId = String()
    var link_to_image = String()
    var name = String()
    var user = String()
    
//    var IMEI : String?
//    var latitude : CLLocationDegrees?
//    var longitude : CLLocationDegrees?
//    var deviceId : String?
//    var link_to_image : String?
//    var name : String?
//    var user : String?
    //--------------------------

    
    func relationRequest() {
        let send : ()->() = {
            self.ws.send("\(self.methodRelation)")
        }
        ws.event.open = {
            send()
            print("Отправлен запрос с параметрами: ","\(self.methodRelation)")
        }
        ws.event.message = { message in
            if let text = message as? String {
        self.convertData = text.stringByReplacingOccurrencesOfString("[\\[\\]]", withString: "", options: .RegularExpressionSearch)
                //Удаление квадратов и возврат норм джсона
                self.relationJSON(self.convertData)
                print(self.convertData)
            }
        }
        ws.event.close = { code, reason, clean in
            print("Подключение разорвано")
        }
        ws.event.error = { error in
            print("Ошибка:  \(error)")
        }
    }

    
    
//    if let long = CLLocationDegrees(String(json["data","longitude"])) {
//        longitude = long
//    }
//    
//    if let lat = CLLocationDegrees(String(json["data","latitude"])){
//        latitude = lat
//    }
    
    
    func relationJSON(text:String){
        
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
            NSNotificationCenter.defaultCenter().postNotificationName("relation", object:nil,userInfo: sendData)
        }
    }
}