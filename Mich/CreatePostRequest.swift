//
//  CreatePostRequest.swift
//  Mich
//
//  Created by zuraba on 2/16/17.
//  Copyright © 2017 Gigi. All rights reserved.
//

import Foundation
import ObjectMapper

class CreatePostRequest: Mappable {
    var token: String?
    var title: String?
    var image: String?
    
    init(token: String, title: String, image: String){
        self.token = token
        self.title = title
        self.image = image
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        token        <- map["token"]
        title        <- map["title"]
        image        <- map["image"]
    }
}
