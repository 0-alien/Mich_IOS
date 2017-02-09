//
//  IsFollowingRequest.swift
//  Mich
//
//  Created by zuraba on 2/9/17.
//  Copyright © 2017 Gigi. All rights reserved.
//

import Foundation
import ObjectMapper

class IsFollowingRequest: Mappable {
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
        id       <- map["userid"]
    }
}
