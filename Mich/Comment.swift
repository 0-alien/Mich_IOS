//
//  Comment.swift
//  Mich
//
//  Created by Gigi Pataraia on 2/28/17.
//  Copyright © 2017 Gigi. All rights reserved.
//

import Foundation
import ObjectMapper

class Comment: Mappable {
    var id: Int?
    var userName: String?
    var avatar: String?
    var nLikes: Int?
    var userId: Int?
    var postId: Int?
    var reply: Int?
    var updatedAt: String?
    var createdAt: String?
    var data: String?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id              <- map["id"]
        userName        <- map["username"]
        avatar          <- map["avatar"]
        nLikes          <- map["nlikes"]
        createdAt       <- map["created_at"]
        updatedAt       <- map["updated_at"]
        userId          <- map["userid"]
        postId          <- map["postId"]
        reply           <- map["reply"]
        data            <- map["data"]
    }
}
