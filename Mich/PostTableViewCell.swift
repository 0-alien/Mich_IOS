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
    
    
    func updateLikeCount(by: Int) {
        likeCount.text = String(Int(likeCount.text!)! + by)
    }
    
    //like from double tap
    func postLiked() {
        if (!self.liked) {
            self.likeDelegate?.postLiked(postIndex: self.index, showAnimation: true)
            self.liked = true
            self.updateLikeCount(by: 1)
        }
        //unlike ar unda qnas double tapze
    }
    
    //like from button
    @IBAction func like(_ sender: Any) {
        if (!self.liked) {
            self.likeDelegate?.postLiked(postIndex: self.index, showAnimation: false)
            self.liked = true
            self.updateLikeCount(by: 1)
        }
        else {
            self.likeDelegate?.postUnliked(postIndex: self.index)
            self.liked = false
            self.updateLikeCount(by: -1)
        }
    }
}

protocol LikesListener {
    func postLiked(postIndex: Int, showAnimation: Bool)
    func postUnliked(postIndex: Int)
}
