//
//  LogoutRequest.swift
//  Mich
//
//  Created by zuraba on 2/1/17.
//  Copyright © 2017 Gigi. All rights reserved.
//

import Foundation
import ObjectMapper

class LogoutRequest: Mappable {
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
