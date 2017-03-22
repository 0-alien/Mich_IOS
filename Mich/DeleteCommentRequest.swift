//
//  DeleteCommentRequest.swift
//  Mich
//
//  Created by zuraba on 3/21/17.
//  Copyright © 2017 Gigi. All rights reserved.
//

import Foundation
import ObjectMapper

class DeleteCommentRequest: Mappable {
    var token: String?
    var commentID: Int?
    
    
    init(token: String, commentID: Int){
        self.token = token
        self.commentID = commentID
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        token           <- map["token"]
        commentID       <- map["commentID"]
        
    }
}
