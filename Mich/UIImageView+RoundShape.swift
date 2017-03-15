//
//  UIImageView+RoundShape.swift
//  Mich
//
//  Created by Gigi Pataraia on 3/15/17.
//  Copyright © 2017 Gigi. All rights reserved.
//

import Foundation
import UIKit
import Swift

extension UIImageView {
    var circle: UIImageView {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
        return self
    }
    var borderedCircle: UIImageView {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
        self.layer.borderWidth = 3
        self.layer.borderColor = UIColor.white.cgColor
        return self
    }
}
