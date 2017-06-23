//
//  VoteBattleRequest.swift
//  Mich
//
//  Created by Gigi Pataraia on 6/22/17.
//  Copyright © 2017 Lemon. All rights reserved.
//

import Foundation
import ObjectMapper

class VoteBattleRequest: Mappable {
    var token: String?
    var battleId: Int?
    var host: Int?
    
    init(token: String, battleId: Int, host: Int) {
        self.token = token
        self.battleId = battleId
        self.host = host
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        token           <- map["token"]
        battleId        <- map["battleID"]
        host            <- map["host"]
    }
}
