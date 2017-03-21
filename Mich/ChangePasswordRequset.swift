//
//  ChangePasswordRequset.swift
//  Mich
//
//  Created by zuraba on 2/7/17.
//  Copyright © 2017 Gigi. All rights reserved.
//

import Foundation
import ObjectMapper

class ChangePasswordRequset: Mappable {
    var token: String?
    var password:String?
    var oldPassword:String?
    
    
    init(token: String, password: String, oldPassword: String){
        self.token = token
        self.password = password
        self.oldPassword = oldPassword
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        token              <- map["token"]
        password           <- map["password"]
        oldPassword        <- map["oldPassword"]
    }
}
