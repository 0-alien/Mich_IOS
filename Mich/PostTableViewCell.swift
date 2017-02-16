//
//  PostTableViewCell.swift
//  Mich
//
//  Created by Gigi Pataraia on 9/26/16.
//  Copyright © 2016 Gigi. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
   
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var commentCount: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    var likeDelegate: LikesListener? = nil
    var index: Int = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func postDoubleTapped() {
        self.likeDelegate?.postLiked(postIndex: self.index, showAnimation: true)
    }
    @IBAction func postLiked(_ sender: Any) {
        self.likeDelegate?.postLiked(postIndex: self.index, showAnimation: false)
    }
    
    //refactor
    @IBAction func like(_ sender: Any) {
         self.likeDelegate?.postLiked(postIndex: self.index, showAnimation: false)
    }
    
}

protocol LikesListener {
    func postLiked(postIndex: Int, showAnimation: Bool)
}
