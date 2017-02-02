//
//  GetCurrentUserResponse.swift
//  Mich
//
//  Created by zuraba on 2/2/17.
//  Copyright © 2017 Gigi. All rights reserved.
//

import Foundation
import ObjectMapper

class GetCurrentUserResponse: Mappable {
    var id: String?
    var name: String?
    var username: String?
    var email: String?
    var avatar: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id          <- map["id"]
        name        <- map["name"]
        username    <- map["username"]
        email       <- map["email"]
        avatar      <- map["avatar"]
    }
}
