//
//  SendRecoveryResponse.swift
//  Mich
//
//  Created by zuraba on 1/31/17.
//  Copyright © 2017 Gigi. All rights reserved.
//

import Foundation
import ObjectMapper

class SendRecoveryResponse: Mappable {
    var token: String?

    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        token    <- map["token"]
    }
}
