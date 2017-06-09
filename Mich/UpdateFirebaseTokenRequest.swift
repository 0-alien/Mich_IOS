//
//  UpdateFirebaseTokenRequest.swift
//  Mich
//
//  Created by Gigi Pataraia on 6/9/17.
//  Copyright © 2017 Lemon. All rights reserved.
//

import Foundation
import ObjectMapper

class UpdateFirebaseTokenRequest: Mappable {
    
    var token: String?
    var fireBaseToken: String?
    
    init(token: String, fireBaseToken: String){
        self.token = token
        self.fireBaseToken = fireBaseToken
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        token           <- map["token"]
        fireBaseToken   <- map["fcmrt"]        
    }
}
