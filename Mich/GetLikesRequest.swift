//
//  GetLikesRequest.swift
//  Mich
//
//  Created by Gigi Pataraia on 12/1/17.
//  Copyright © 2017 Lemon. All rights reserved.
//

import Foundation
import ObjectMapper

class GetLikesRequest: Mappable {
    var token: String?
    var postId: Int?
    
    init(token: String, postId: Int){
        self.token = token
        self.postId = postId
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        token       <- map["token"]
        postId      <- map["postID"]
    }
}
