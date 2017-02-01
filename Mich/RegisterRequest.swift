//
//  RegisterRequest.swift
//  Mich
//
//  Created by zuraba on 1/17/17.
//  Copyright © 2017 Gigi. All rights reserved.
//

import Foundation
import ObjectMapper

class RegisterRequest: Mappable {
    var username :String?
    var email: String?
    var password: String?
    var name: String?
    
    
    init(username:String, email: String, password: String, name: String){
        self.username = username
        self.email = email
        self.password = password
        self.name = name

    
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        username    <- map["username"]
        email       <- map["email"]
        password    <- map["password"]
        name        <- map["name"]
        
    }
}
