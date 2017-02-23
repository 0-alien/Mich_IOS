//
//  GetUsersFollowingRequest.swift
//  Mich
//
//  Created by zuraba on 2/22/17.
//  Copyright © 2017 Gigi. All rights reserved.
//

import Foundation
import ObjectMapper

class GetUsersFollowingRequest: Mappable {
    var token: String?
    var id: Int?
    
    init(token: String, id: Int){
        self.token = token
        self.id = id
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        token    <- map["token"]
        id       <- map["userID"]
    }
}
