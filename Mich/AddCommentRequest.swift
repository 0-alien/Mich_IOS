//
//  AddCommentRequest.swift
//  Mich
//
//  Created by zuraba on 2/27/17.
//  Copyright © 2017 Gigi. All rights reserved.
//

import Foundation
import ObjectMapper

class AddCommentRequest: Mappable {
    var token: String?
    var postID: Int?
    var comment: String?
    
    init(token: String, postID: Int, comment: String){
        self.token = token
        self.postID = postID
        self.comment = comment
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        token        <- map["token"]
        postID       <- map["postID"]
        comment      <- map["comment"]
    }
}
