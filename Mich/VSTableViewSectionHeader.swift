//
//  VSTableViewSectionHeader.swift
//  Mich
//
//  Created by Gigi Pataraia on 10/10/16.
//  Copyright © 2016 Gigi. All rights reserved.
//

import UIKit

class VSTableViewSectionHeader: UIView {
    var sectionLabel: UILabel = UILabel()
    var seeMoreButton: UIButton = UIButton()
    required init?(coder aDecoder: NSCoder) {
        fatalError("WTF")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(sectionLabel)
        addSubview(seeMoreButton)
    }
    
    convenience init(frame: CGRect, labelName: String, seeMoreCount: Int, listener: AnyObject, selector: Selector) {
        self.init(frame: frame)
        
        sectionLabel.font = UIFont(name: "Helvetica", size: 12)
        sectionLabel.text = labelName
        
        seeMoreButton.addTarget(listener, action: selector, for: .touchDown)
        seeMoreButton.setTitle("See More(" + String(seeMoreCount) + ") ", for: .normal)
        seeMoreButton.titleLabel?.font = UIFont(name: "Helvetica", size: 12)
        seeMoreButton.contentHorizontalAlignment = .right
        
        self.backgroundColor = UIColor.gray
    }
    
    
    override func layoutSubviews() {
        let buttonHeight = Int(frame.size.height)
        let buttonWidth = Int(frame.size.width / 2.0)
        var buttonFrame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
        buttonFrame.origin.x = 0
        sectionLabel.frame = buttonFrame
        buttonFrame.origin.x = frame.size.width / 2.0
        seeMoreButton.frame = buttonFrame
    }
    

    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
