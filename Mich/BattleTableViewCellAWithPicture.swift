//
//  BattleTableViewCellAWithPicture.swift
//  Mich
//
//  Created by Gigi Pataraia on 1/31/17.
//  Copyright © 2017 Gigi. All rights reserved.
//

import UIKit

class BattleTableViewCellAWithPicture: UITableViewCell {

    @IBOutlet weak var sentImageHeight: NSLayoutConstraint!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var sentImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
