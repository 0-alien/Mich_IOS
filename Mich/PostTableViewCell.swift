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
    var liked: Bool! {
        didSet {
            if liked! {
                self.likeButton.backgroundColor = UIColor.red
            }
            else {
                self.likeButton.backgroundColor = self.backgroundColor
            }
        }
    }
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
        self.liked = !self.liked!
        if liked! {
            self.likeDelegate?.postLiked(postIndex: self.index, showAnimation: true)
            self.updateLikeCount(by: 1)
        }
        else {
            self.likeDelegate?.postUnliked(postIndex: self.index)
            self.updateLikeCount(by: -1)
        }
    }
    
    func updateLikeCount(by: Int) {
        likeCount.text = String(Int(likeCount.text!)! + by)
    }
    
    //refactor
    @IBAction func like(_ sender: Any) {
        self.liked = !self.liked!
        if liked! {
            self.likeDelegate?.postLiked(postIndex: self.index, showAnimation: false)
            self.updateLikeCount(by: 1)
        }
        else {
            self.likeDelegate?.postUnliked(postIndex: self.index)
            self.updateLikeCount(by: -1)
        }
    }
    
}

protocol LikesListener {
    func postLiked(postIndex: Int, showAnimation: Bool)
    func postUnliked(postIndex: Int)
}
