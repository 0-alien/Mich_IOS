//
//  TogglePrivacyStatusRequest.swift
//  Mich
//
//  Created by zuraba on 11/2/17.
//  Copyright © 2017 Lemon. All rights reserved.
//

import Foundation
import ObjectMapper

class TogglePrivacyStatusRequest: Mappable {
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

