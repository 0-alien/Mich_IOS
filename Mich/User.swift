//
//  GetCurrentUserResponse.swift
//  Mich
//
//  Created by zuraba on 2/2/17.
//  Copyright © 2017 Gigi. All rights reserved.
//

import Foundation
import ObjectMapper

class User: Mappable {
    var id: Int?
    var name: String?
    var username: String?
    var email: String?
    var avatar: String?
    var nfollowers: Int?
    var nfollowing: Int?
    var record: String?
    var blocked: Bool?
    var votes: Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id              <- map["id"]
        name            <- map["name"]
        username        <- map["username"]
        email           <- map["email"]
        avatar          <- map["avatar"]
        nfollowers      <- map["nfollowers"]
        nfollowing      <- map["nfollowing"]
        record          <- map["record"]
        blocked         <- map["blocked"]
        votes           <- map["votes"]
    }
}
