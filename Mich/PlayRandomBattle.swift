//
//  GetRandomBattleRequest.swift
//  Mich
//
//  Created by Gigi Pataraia on 8/11/17.
//  Copyright © 2017 Lemon. All rights reserved.
//

import Foundation
import ObjectMapper

class PlayRandomBattleRequest: Mappable {
    var token:  String?
    var filter: String?
    
    init(token: String, filter:String){
        self.token = token
        self.filter = filter
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        token    <- map["token"]
        filter   <- map["filter"]
    }
}
