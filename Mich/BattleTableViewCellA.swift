//
//  BattleTableViewCell.swift
//  Mich
//
//  Created by Gigi Pataraia on 11/3/16.
//  Copyright © 2016 Gigi. All rights reserved.
//

import UIKit

class BattleTableViewCellA: UITableViewCell {

   
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
