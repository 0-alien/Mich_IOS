//
//  AskQuestionRequest.swift
//  Mich
//
//  Created by zuraba on 6/6/17.
//  Copyright © 2017 Lemon. All rights reserved.
//

import Foundation
import ObjectMapper

class AskQuestionRequest: Mappable {
    var question: String?
    
    
    
    init(question: String){
        self.question = question
        
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        question      <- map["question"]
        
    }
}
