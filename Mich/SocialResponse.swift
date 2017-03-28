//
//  SocialResponse.swift
//  Mich
//
//  Created by zuraba on 3/24/17.
//  Copyright © 2017 Gigi. All rights reserved.
//

import Foundation
import ObjectMapper

class SocialResponse: Mappable {
    var url: String?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        url    <- map["url"]
    }
}
