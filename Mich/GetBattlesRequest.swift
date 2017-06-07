//
//  GetBattlesRequest.swift
//  Mich
//
//  Created by Gigi Pataraia on 6/7/17.
//  Copyright © 2017 Lemon. All rights reserved.
//

import Foundation
import ObjectMapper

class GetBattlesRequest: Mappable {
    var token: String?
    
    init(token: String){
        self.token = token
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        token    <- map["token"]
    }
}
