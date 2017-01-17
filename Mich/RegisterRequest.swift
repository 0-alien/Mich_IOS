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
    var email: String?
    var password: String?
    var firstname: String?
    var lastname: String?
    var type: Int?
    
    
    init(email: String, password: String, firstname: String, lastname: String, type: Int){
        self.email = email
        self.password = password
        self.firstname = firstname
        self.lastname = lastname
        self.type = type
    
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        email       <- map["email"]
        password    <- map["password"]
        firstname   <- map["firstname"]
        lastname    <- map["lastname"]
        
        type        <- map["type"]
    }
}
