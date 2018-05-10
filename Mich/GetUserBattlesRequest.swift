//
//  GetUserBattles.swift
//  Mich
//
//  Created by Gigi Pataraia on 5/7/18.
//  Copyright © 2018 Lemon. All rights reserved.
//

import Foundation
import ObjectMapper

class GetUserBattleRequest: Mappable {
    var token: String?
    var userId: Int?
    
    init(token: String, userId: Int?){
        self.token = token
        self.userId = userId
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        token        <- map["token"]
        userId       <- map["userID"]
    }
}

