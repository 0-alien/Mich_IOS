//
//  VSTableViewCell.swift
//  Mich
//
//  Created by Gigi Pataraia on 10/10/16.
//  Copyright © 2016 Gigi. All rights reserved.
//

import UIKit

class VSTableViewCell: UITableViewCell {

    
    @IBOutlet weak var vsFirst: UIImageView!
    @IBOutlet weak var vsSecond: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        vsFirst.image = vsFirst.image?.circle
        vsSecond.image = vsSecond.image?.circle
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
