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
    let methodAuth : JSON = ["method":"auth","data":["token":"\(TokenManager.mainToken)"]]
    let methodRelation : JSON = ["method":"list_relation","data":["token":"\(TokenManager.mainToken)"]]
    var codeError = String()
    
//--------------------------
    
    func connectSockets(){
        let send : ()->() = {
            self.ws.send("\(self.methodAuth)")
        }
        ws.event.open = {
            send()
            print("Соединение впорядке")
        }
        ws.event.close = { code, reason, clean in
            print("Соединение разорвано")
        }
        ws.event.message = { message in
            if let text = message as? String {
               
                self.delegateMethod(text)
                //Здесь приходит ответ в JSON'е, который потом отправляется путешесвтовать в конверт и уже от туда выдергивается код ошибки. РАУНД.
            }
        }
    }
    
    func coconvertJSON(text:String) ->Bool{
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            let json = JSON(data:data)
            codeError = String(json["data"]["code"])
            
            if codeError == "666" {
                return true
            }else if codeError == "66"{
                print("Code = 66")
            }
        }
    return false
    }
    
    func delegateMethod(jsonRaw: String){
        if let data = jsonRaw.dataUsingEncoding(NSUTF8StringEncoding) {
            let json = JSON(data:data)
            var method = String()
            method = String(json["method"])
            
            if(method=="auth"){
                self.ws.send(self.methodRelation)
            }
            
            else if(method=="list_relation"){
                
                let convertData = jsonRaw.stringByReplacingOccurrencesOfString("[\\[\\]]", withString: "", options: .RegularExpressionSearch)
                    //Удаление квадратов и возврат норм джсона
                controllerRelation(convertData)
                
            }
            }
            
        }
    }
    
    func controllerRelation(text: String){
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
            NSNotificationCenter.defaultCenter().postNotificationName("relation", object:nil,userInfo: sendData)
        }
}