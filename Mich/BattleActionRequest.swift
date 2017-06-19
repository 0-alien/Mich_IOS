//
//  AcceptBattleRequest.swift
//  Mich
//
//  Created by Gigi Pataraia on 6/14/17.
//  Copyright © 2017 Lemon. All rights reserved.
//

import Foundation
import ObjectMapper

class BattleActionRequest: Mappable {
    var token: String?
    var battleId: Int?
    
    init(token: String, battleId: Int){
        self.token = token
        self.battleId = battleId
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        token           <- map["token"]
        battleId        <- map["battleID"]
    }
}
