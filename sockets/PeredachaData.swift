//
//  PeredachaData.swift
//  sockets
//
//  Created by Zakhar Rudenko on 08.05.16.
//  Copyright © 2016 Zakhar Rudenko. All rights reserved.
//

import Foundation
import SwiftyJSON

struct TokenManager {

    static var token :String = ""
    
    static func getAuth(token:String) -> JSON {
        return ["method":"auth","data":["token":"\(token)"]]
    }
    
    static func getRelation(token:String) ->JSON{
        return ["method":"list_relation","data":["token":"\(token)"]]
    }
    
    static func setToken(token:String) {
        self.token = token
    }
    
    static func getToken()-> String{
        return token
    }
    
}