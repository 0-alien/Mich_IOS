//
//  IsFollowerResponse.swift
//  Mich
//
//  Created by zuraba on 2/10/17.
//  Copyright © 2017 Gigi. All rights reserved.
//

import Foundation
import ObjectMapper

class IsFollowerResponse: Mappable {
    var result: Bool?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        result    <- map["result"]
    }
}
