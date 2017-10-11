//
//  ChatMessage.swift
//  Mich
//
//  Created by Gigi Pataraia on 10/11/17.
//  Copyright © 2017 Lemon. All rights reserved.
//

import Foundation
import ObjectMapper

class ChatMessage : Mappable {
    var id: String?
    var text: String?
    var senderId: Int?
    var senderDisplayName: String?
    
    init(id: String, senderId: Int, senderDisplayName: String, text: String) {
        self.id = id
        self.senderId = senderId
        self.senderDisplayName = senderDisplayName
        self.text = text
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        senderId            <- map["senderid"]
        text                <- map["text"]
        senderDisplayName   <- map["sendername"]
    }
}
