//
//  SearchResultsTableViewCell.swift
//  Mich
//
//  Created by Gigi Pataraia on 12/22/16.
//  Copyright © 2016 Gigi. All rights reserved.
//

import UIKit

class SearchResultsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
