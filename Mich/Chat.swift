//
//  Chat.swift
//  Mich
//
//  Created by Gigi Pataraia on 10/9/17.
//  Copyright © 2017 Lemon. All rights reserved.
//

import Foundation
import ObjectMapper

class Chat: Mappable {
    var id: Int?
    var user: User?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id              <- map["id"]
        user            <- map["user"]
    }
}

