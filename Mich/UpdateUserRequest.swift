//
//  UpdateUserRequest.swift
//  Mich
//
//  Created by zuraba on 3/14/17.
//  Copyright © 2017 Gigi. All rights reserved.
//

import Foundation
import ObjectMapper

class UpdateUserRequest: Mappable {
    var token: String?
    var name: String?
    var username: String?
    var email: String?
    var avatar: String?
    
    init(token: String, name: String, username: String, email: String, avatar: String){
        self.token = token
        self.name  = name
        self.username  = username
        self.email = email
        self.avatar = avatar
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        token        <- map["token"]
        name         <- map["name"]
        username     <- map["username"]
        email        <- map["email"]
        avatar       <- map["avatar"]
    }
}
