//
//  LoginResponsee.swift
//  Mich
//
//  Created by Gigi Pataraia on 9/7/17.
//  Copyright © 2017 Lemon. All rights reserved.
//

import Foundation
import ObjectMapper

class LoginResponse: Mappable {
    
    var token: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        token   <- map["token"]
    }
}
