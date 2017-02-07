//
//  PostClass.swift
//  Mich
//
//  Created by zuraba on 2/3/17.
//  Copyright © 2017 Gigi. All rights reserved.
//

import Foundation
import ObjectMapper

class PostClass: Mappable {
    var id: Int?
    var userId: Int?
    var title: String?
    var image: String?
    var created_at: String?
    var updated_at: String?
    var likeCnt: Int?
    
    
    required init?(map: Map) {
        
    }
    
    init(_ id: Int?, userId: Int?, title: String?, image: String, created_at: String?, updated_at: String?, likeCnt: Int?) {
        self.id = id
        self.userId = userId
        self.title = title
        self.image = image
        self.created_at = created_at
        self.updated_at = updated_at
        self.likeCnt = likeCnt
    }
    
    func mapping(map: Map) {
        id              <- map["id"]
        userId          <- map["userid"]
        title           <- map["title"]
        image           <- map["image"]
        created_at      <- map["created_at"]
        updated_at      <- map["updated_at"]
        likeCnt         <- map["likes"]
    }
}
