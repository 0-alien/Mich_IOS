//
//  VSBattleNavBarView.swift
//  Mich
//
//  Created by Gigi Pataraia on 10/13/16.
//  Copyright © 2016 Gigi. All rights reserved.
//

import UIKit

class VSBattleNavBarView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var firstImageView = UIImageView()
    var secondImageView = UIImageView()
    var firstScoreLabel = UILabel()
    var secondScoreLabel = UILabel()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    convenience init(frame: CGRect, firstImage: UIImage, firstScore: Int, secondImage: UIImage, secondScore: Int) {
        self.init(frame: frame)
        firstImageView = UIImageView(image: firstImage)
        secondImageView = UIImageView(image: secondImage)
        firstScoreLabel = UILabel()
        secondScoreLabel = UILabel()
        firstScoreLabel.text = String(firstScore)
        secondScoreLabel.text = String(secondScore)
        addSubview(firstImageView)
        addSubview(secondImageView)
        addSubview(firstScoreLabel)
        addSubview(secondScoreLabel)
        self.backgroundColor = UIColor.green
    }
    
    override func layoutSubviews() {
        let imageSize = min(frame.size.width / 5, frame.size.height / 1.2)
        var imageaFrame = CGRect(x: 0, y: 0, width: imageSize, height: imageSize)
        imageaFrame.origin.x = 0
        firstImageView.frame = imageaFrame
        imageaFrame.origin.x = frame.size.width / 2
        secondImageView.frame = imageaFrame
    }
}
