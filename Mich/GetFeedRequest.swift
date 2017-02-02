//
//  GetFeedRequest.swift
//  Mich
//
//  Created by zuraba on 2/2/17.
//  Copyright © 2017 Gigi. All rights reserved.
//

import Foundation
import ObjectMapper

class GetFeedRequest: Mappable {
    var token: String?
    
    
    init(token: String){
        self.token = token
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        token    <- map["token"]
    }
}
