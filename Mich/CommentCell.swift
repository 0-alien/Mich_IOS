//
//  CommentsTableViewCell.swift
//  Mich
//
//  Created by Gigi Pataraia on 11/15/16.
//  Copyright © 2016 Gigi. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userPicture: UIImageView!
    @IBOutlet weak var answersButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
