//
//  RecoverRequest.swift
//  Mich
//
//  Created by zuraba on 2/1/17.
//  Copyright © 2017 Gigi. All rights reserved.
//



import Foundation
import ObjectMapper

class RecoverRequest: Mappable {
    var token: String?
    var password: String?
    
    
    init(token: String?, password:String?){
        self.token = token
        self.password = password
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        token    <- map["token"]
        password    <- map["password"]
    }
}
