//
//  NotificationsTableViewCell.swift
//  Mich
//
//  Created by Gigi Pataraia on 6/22/17.
//  Copyright © 2017 Lemon. All rights reserved.
//

import UIKit

class NotificationsTableViewCell: UITableViewCell {
    @IBOutlet weak var userPicture: UIImageView!
    @IBOutlet weak var data: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
