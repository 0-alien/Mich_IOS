//
//  BaseResponseArray.swift
//  Mich
//
//  Created by zuraba on 2/3/17.
//  Copyright © 2017 Gigi. All rights reserved.
//

import Foundation
import ObjectMapper

class BaseResponseArray<T: Mappable> : Mappable {
    var code: Int?
    var message: String?
    var data: [T]?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        code    <- map["code"]
        message <- map["message"]
        data    <- map["data"]
    }
    
}


class BaseResponseArrayX<T> : Mappable {
    var code: Int?
    var message: String?
    var data: [T]?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        code    <- map["code"]
        message <- map["message"]
        data    <- map["data"]
    }
    
}
