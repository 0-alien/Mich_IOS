//
//  IsFollowingResponse.swift
//  Mich
//
//  Created by zuraba on 2/9/17.
//  Copyright © 2017 Gigi. All rights reserved.
//

import Foundation
import ObjectMapper

class IsFollowingResponse: Mappable {
    var result: Bool?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        result    <- map["result"]
    }
}
