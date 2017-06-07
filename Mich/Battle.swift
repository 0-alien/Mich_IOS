//
//  VS.swift
//  Mich
//
//  Created by Gigi Pataraia on 6/7/17.
//  Copyright © 2017 Lemon. All rights reserved.
//

import Foundation
import ObjectMapper

class Battle: Mappable {
    var id: Int?
    var status: Int?
    var myBattle: Bool?
    var iAmHost: Bool?
    var iAmGuest: Bool?
    var createAt: String?
    var updatedAt: String?
    var host: User?
    var guest: User?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id              <- map["id"]
        status          <- map["status"]
        host            <- map["host"]
        guest           <- map["guest"]
        myBattle        <- map["mybattle"]
        iAmHost         <- map["iamhost"]
        iAmGuest        <- map["iamguest"]
        createAt        <- map["created_at"]
        updatedAt       <- map["updated_at"]
    }
}
