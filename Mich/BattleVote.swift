//
//  BattleVote.swift
//  Mich
//
//  Created by Gigi Pataraia on 6/23/17.
//  Copyright © 2017 Lemon. All rights reserved.
//

import Foundation
import ObjectMapper

class BattleVote : Mappable {
    var guestVotes: Int?
    var hostVotes: Int?
    
    init(host: Int, guest: Int) {
        self.guestVotes = guest
        self.hostVotes = host
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        guestVotes      <- map["guest"]
        hostVotes       <- map["host"]
    }
}
