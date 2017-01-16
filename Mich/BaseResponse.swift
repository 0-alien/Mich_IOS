//
//  BaseResponse.swift
//  Mich
//
//  Created by zuraba on 1/13/17.
//  Copyright © 2017 Gigi. All rights reserved.
//

import Foundation
import ObjectMapper

class BaseResponse<T: Mappable> : Mappable {
    var code: Int?
    var message: String?
    var data: T?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        code    <- map["code"]
        message <- map["message"]
        data    <- map["data"]
    }
    
}
