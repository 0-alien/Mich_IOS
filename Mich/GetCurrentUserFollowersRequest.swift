//
//  GetCurrentUserFollowersRequest.swift
//  Mich
//
//  Created by zuraba on 2/10/17.
//  Copyright © 2017 Gigi. All rights reserved.
//

import Foundation
import ObjectMapper

class GetCurrentUserFollowersRequest: Mappable {
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
