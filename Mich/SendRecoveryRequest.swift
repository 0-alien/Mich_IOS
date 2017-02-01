//
//  SendRecoveryRequest.swift
//  Mich
//
//  Created by zuraba on 1/31/17.
//  Copyright © 2017 Gigi. All rights reserved.
//

import Foundation
import ObjectMapper

class SendRecoveryRequest: Mappable {
    var username: String?

    
    init(username: String){
        self.username = username
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        username    <- map["username"]
    }
}
