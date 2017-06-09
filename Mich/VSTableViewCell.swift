//
//  VSTableViewCell.swift
//  Mich
//
//  Created by Gigi Pataraia on 10/10/16.
//  Copyright © 2016 Gigi. All rights reserved.
//

import UIKit

class VSTableViewCell: UITableViewCell {

    @IBOutlet weak var hostUserName: UILabel!
    @IBOutlet weak var vsFirst: UIImageView!
    @IBOutlet weak var vsSecond: UIImageView!
    @IBOutlet weak var guestUserName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
