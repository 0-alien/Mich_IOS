//
//  BattleTableViewCell.swift
//  Mich
//
//  Created by Gigi Pataraia on 1/30/17.
//  Copyright © 2017 Gigi. All rights reserved.
//

import UIKit

class BattleTableViewCell {
    var isFirst: Bool!
    var hasImage: Bool!
    var label: String!
    var image: UIImage?
    
    init() {
        isFirst = true
        hasImage = false
        label = ""
        image = nil
    }
    
    init(withData isFirst: Bool, hasImage: Bool, label: String, image: UIImage?) {
        self.isFirst = isFirst
        self.hasImage = hasImage
        self.label = label
        self.image = image
    }
}
