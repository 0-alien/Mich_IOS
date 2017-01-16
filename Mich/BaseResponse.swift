//
//  BaseResponse.swift
//  Mich
//
//  Created by zuraba on 1/13/17.
//  Copyright © 2017 Gigi. All rights reserved.
//

import Foundation
import ObjectMapper

class BaseResponse: Mappable {
    var code: Int?
    var message: String?
    var data: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        code    <- map["code"]
        message <- map["message"]
    }
    
}
