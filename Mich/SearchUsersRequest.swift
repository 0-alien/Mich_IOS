//
//  SearchUsersRequest.swift
//  Mich
//
//  Created by zuraba on 2/17/17.
//  Copyright © 2017 Gigi. All rights reserved.
//

import Foundation
import ObjectMapper

class SearchUsersRequest: Mappable {
    var token: String?
    var term: String?
    
    init(token: String, term: String){
        self.token = token
        self.term = term
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        token        <- map["token"]
        term         <- map["term"]
    }
}
