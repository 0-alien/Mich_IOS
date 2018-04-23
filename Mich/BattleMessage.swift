//
//  Message.swift
//  Mich
//
//  Created by Gigi Pataraia on 6/20/17.
//  Copyright © 2017 Lemon. All rights reserved.
//
import Foundation
import ObjectMapper

class BattleMessage : Mappable {
    var id: String?
    var text: String?
    var senderId: Int?
    var senderDisplayName: String?
    var isMedia: Bool! = false
    
    init(id: String, senderId: Int, senderDisplayName: String, text: String) {
        self.id = id
        self.senderId = senderId
        self.senderDisplayName = senderDisplayName
        self.text = text
    }
    
    init(id: String, senderId: Int, senderDisplayName: String, text: String, isMedia: Bool) {
        self.id = id
        self.senderId = senderId
        self.senderDisplayName = senderDisplayName
        self.text = text
        self.isMedia = isMedia
    }
    
    required init?(map: Map) {
        
    }
    
    func setPhoto(isMedia: Bool) {
        self.isMedia = isMedia
    }
    func getPhoto() -> Bool {
        return self.isMedia
    }
    
    func mapping(map: Map) {
        senderId            <- map["senderid"]
        text                <- map["text"]
        senderDisplayName   <- map["sendername"]
        isMedia             <- map["ismedia"]
    }
}
