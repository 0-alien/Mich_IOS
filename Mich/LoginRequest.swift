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
    var token: String?
    var type: Int?
    
    
    init(username: String, password: String, token: String, type: Int){
        self.username = username
        self.password = password
        self.token = token
        self.type = type
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        username    <- map["username"]
        password    <- map["password"]
        type        <- map["type"]
        token       <- map["fcmrt"]
    }
}
