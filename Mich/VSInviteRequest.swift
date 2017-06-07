//
//  VSInviteRequest.swift
//  Mich
//
//  Created by Gigi Pataraia on 6/7/17.
//  Copyright © 2017 Lemon. All rights reserved.
//

import Foundation
import ObjectMapper

class VSInviteRequest: Mappable {
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
