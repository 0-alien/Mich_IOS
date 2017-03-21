//
//  MichNotification.swift
//  Mich
//
//  Created by Gigi Pataraia on 3/21/17.
//  Copyright © 2017 Gigi. All rights reserved.
//

import Foundation
import ObjectMapper

class MichNotification: Mappable {
    var id: Int?
    var type: Int?
    var itemId: Int?
    var message: String?
    var status: Int?
    var userId: Int?
    var createdAt: String?
    var updatedAt: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id              <- map["id"]
        type            <- map["type"]
        itemId          <- map["itemid"]
        message         <- map["message"]
        status          <- map["status"]
        userId          <- map["userid"]
        createdAt       <- map["created_at"]
        updatedAt       <- map["updated_at"]
    }
}

