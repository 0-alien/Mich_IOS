//
//  LikesTableViewCell.swift
//  Mich
//
//  Created by Gigi Pataraia on 4/5/17.
//  Copyright © 2017 Gigi. All rights reserved.
//

import UIKit

class LikesTableViewCell: UITableViewCell {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userPicture: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
