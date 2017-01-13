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
    var email: String?
    var password: String?
    var type: Int?
    
    
    init(email: String, password: String, type: Int){
        self.email = email
        self.password = password
        self.type = type
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        email       <- map["email"]
        password    <- map["password"]
        type        <- map["type"]
    }
}
