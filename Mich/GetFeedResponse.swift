//
//  GetFeedResponse.swift
//  Mich
//
//  Created by zuraba on 2/2/17.
//  Copyright © 2017 Gigi. All rights reserved.
//

import Foundation
import ObjectMapper

class GetFeedResponse: Mappable {
    var arrayOfPosts: [PostClass]?
    
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        arrayOfPosts <- map

    }
}

