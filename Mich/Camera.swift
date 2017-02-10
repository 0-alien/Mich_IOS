//
//  Camera.swift
//  Mich
//
//  Created by Gigi Pataraia on 2/10/17.
//  Copyright © 2017 Gigi. All rights reserved.
//

import UIKit

@IBDesignable class Camera: UIView {

    @IBOutlet weak var gallery: UIButton!
    @IBOutlet weak var camera: UIButton!
    var view: UIView!
    @IBOutlet weak var chooseImage: UIImageView!
    override init(frame: CGRect) {
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        xibSetup()
    }

    func xibSetup() {
        
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        print(bundle)
        let nib = UINib(nibName: "Camera", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
