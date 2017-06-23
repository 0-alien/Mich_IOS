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
    var which: String?
    var votes: Int?
    
    init(which: String, votes: Int) {
        self.which = which
        self.votes = votes
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        votes               <- map["votes"]
    }
}
