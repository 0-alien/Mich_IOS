//
//  MarkSingleNotificationSeenRequest.swift
//  Mich
//
//  Created by Gigi Pataraia on 6/2/17.
//  Copyright © 2017 Lemon. All rights reserved.
//

import Foundation
import ObjectMapper

class MarkSingleNotificationSeenRequest: Mappable {
    var token: String?
    var notificationId: Int?
    
    init(token: String, notificationId: Int){
        self.token = token
        self.notificationId = notificationId
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        token                <- map["token"]
        notificationId       <- map["notificationID"]
    }
}

