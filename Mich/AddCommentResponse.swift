//
//  AddCommentResponse.swift
//  Mich
//
//  Created by zuraba on 2/27/17.
//  Copyright © 2017 Gigi. All rights reserved.
//

import Foundation
import ObjectMapper

class AddCommentResponse: Mappable {
    
    var comment: Comment?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        comment       <- map["comment"]
    }
}
