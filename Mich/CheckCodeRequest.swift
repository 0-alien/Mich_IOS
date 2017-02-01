//
//  CheckCodeRequest.swift
//  Mich
//
//  Created by zuraba on 2/1/17.
//  Copyright © 2017 Gigi. All rights reserved.
//

import Foundation
import ObjectMapper

class CheckCodeRequest: Mappable {
    var token: String?
    var code: String?
    
    
    init(token: String?, code:String?){
        self.token = token
        self.code = code
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        token    <- map["token"]
        code    <- map["code"]
    }
}
