//
//  ConnectSockets.swift
//  sockets
//
//  Created by Zakhar Rudenko on 30.03.16.
//  Copyright © 2016 Zakhar Rudenko. All rights reserved.
//

import SwiftWebSocket
import SwiftyJSON

class ConnectSockets : UIViewController {
    
    let ws = WebSocket("ws://176.56.50.175:8000/core/socket/new/")
    let methodAuth : JSON = ["method":"auth","data":["token":"\(TokenManager.mainToken)"]]
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
                self.coconvertJSON(text)
                print(text)
                //Здесь приходит ответ в JSON'е, который потом отправляется путешесвтовать в конверт и уже от туда выдергивается код ошибки. РАУНД.
            }
        }
    }
    
    func coconvertJSON(text:String) {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            let json = JSON(data:data)
            codeError = String(json["data"]["code"])
            
            if codeError == "77" {
                print("Code = 77")
            }else if codeError == "66"{
                print("Code = 66")
            }
        }
    }
}