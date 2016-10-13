//
//  Footer.swift
//  Mich
//
//  Created by Gigi Pataraia on 9/16/16.
//  Copyright © 2016 Gigi. All rights reserved.
//

import UIKit

class Footer: UIView {
    var footerButtons = [UIButton]()
    let imageNames = ["home_icon", "vs_icon", "camera_icon", "mich_icon", "env_icon"];
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor(red: 205 / 255.0, green: 60 / 255.0, blue: 28 / 255.0, alpha: 1)
        for icon in imageNames {
            let button = UIButton()
            button.setImage(UIImage(named: icon), for: .normal)
            button.setImage(UIImage(named: icon), for: .selected)
            button.setImage(UIImage(named: icon), for: [.highlighted, .selected])
            
            button.addTarget(self, action: #selector(Footer.ratingButtonTapped(_:)), for: .touchUpInside)
            //button.addTarget(self, action: #selector(Footer.ratingButtonTouchUp(_:)), for: .touchUpInside)
            footerButtons += [button]
            addSubview(button)
        }
        footerButtons[0].backgroundColor = UIColor(red: 225 / 255.0, green: 60 / 255.0, blue: 28 / 255.0, alpha: 1)
    }
    
    override func layoutSubviews() {
        let buttonHeight = Double(frame.size.height)
        let buttonWidth = Double(frame.size.width / 5.0)
        //let spacing = (Double(frame.size.width) - (Double)(5 * frame.size.height)) / 4.0
        var buttonFrame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
        
        // Offset each button's origin by the length of the button plus spacing.
        for (index, button) in footerButtons.enumerated() {
            buttonFrame.origin.x = CGFloat(Double(index) * (buttonWidth))
            button.frame = buttonFrame
        }
    }
    func ratingButtonTapped(_ button: UIButton) {
        let _ = footerButtons.index(of: button)!
        for but in footerButtons {
            but.backgroundColor = UIColor(red: 205 / 255.0, green: 60 / 255.0, blue: 28 / 255.0, alpha: 1)
        }
        button.backgroundColor = UIColor(red: 225 / 255.0, green: 60 / 255.0, blue: 28 / 255.0, alpha: 1)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
