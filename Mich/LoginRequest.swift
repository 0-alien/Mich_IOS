//
//  LoginRequest.swift
//  Mich
//
//  Created by zuraba on 1/13/17.
//  Copyright © 2017 Gigi. All rights reserved.
//

import Foundation
import ObjectMapper

class LoginRequest: Mappable {
    var username: String?
    var password: String?
    var type: Int?
    var fcmrt: String?
    
    
    init(username: String, password: String, type: Int, fcmrt: String){
        self.username = username
        self.password = password
        self.type = type
        self.fcmrt = fcmrt
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        username    <- map["username"]
        password    <- map["password"]
        type        <- map["type"]
        fcmrt       <- map["fcmrt"]
    }
}
