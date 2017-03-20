//
//  HidePostRequest.swift
//  Mich
//
//  Created by zuraba on 3/20/17.
//  Copyright © 2017 Gigi. All rights reserved.
//

import Foundation
import ObjectMapper

class HidePostRequest: Mappable {
    var token: String?
    var postID: Int?
    
    
    init(token: String, postID: Int){
        self.token = token
        self.postID = postID
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        token        <- map["token"]
        postID       <- map["postID"]
        
    }
}
