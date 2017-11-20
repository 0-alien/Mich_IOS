//
//  GetChatRequest.swift
//  Mich
//
//  Created by Gigi Pataraia on 10/11/17.
//  Copyright © 2017 Lemon. All rights reserved.
//

import Foundation
import ObjectMapper

class GetChatRequest: Mappable {
    var token: String?
    var userId: Int?
    
    init(token: String, userId: Int){
        self.token = token
        self.userId = userId
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        token    <- map["token"]
        userId   <- map["userID"]
    }
}
