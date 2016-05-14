//
//  Obossish.swift
//  sockets
//
//  Created by Zakhar Rudenko on 30.03.16.
//  Copyright © 2016 Zakhar Rudenko. All rights reserved.
//

import Foundation
import MapKit

class UserDataClass {
    
    var IMEI : String?
    var latitude : CLLocationDegrees?
    var longitude : CLLocationDegrees?
    var deviceId : String?
    var link_to_image : String?
    var name : String?
    var user : String?
    
    init(IMEI:String,latitude:CLLocationDegrees,longitude:CLLocationDegrees,deviceId:String,link_to_image:String,name:String,user:String){
        self.latitude = latitude
        self.longitude = longitude
        self.IMEI = IMEI
        self.deviceId = deviceId
        self.link_to_image = link_to_image
        self.name = name
        self.user = user
    }
}