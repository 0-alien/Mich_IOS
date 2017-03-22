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
    @IBOutlet weak var createdAt: UILabel!
    
    var liked: Bool! {
        didSet {
            if liked! {
                self.likeButton.setImage(UIImage(named: "liked_icon"), for: .normal)
            }
            else {
                self.likeButton.setImage(UIImage(named: "like_icon"), for: .normal)
            }
        }
    }
    var cellDelegate: PostTableViewCellDelegate? = nil
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
            self.cellDelegate?.postLiked(cellIndex: self.index, showAnimation: true)
            self.liked = true
            self.updateLikeCount(by: 1)
        }
        //unlike ar unda qnas double tapze
    }
    
    func showProfile() {
        self.cellDelegate?.showProfile(cellIndex: self.index)
    }
    
    //like from button
    @IBAction func like(_ sender: Any) {
        if (!self.liked) {
            self.cellDelegate?.postLiked(cellIndex: self.index, showAnimation: false)
            self.liked = true
            self.updateLikeCount(by: 1)
        }
        else {
            self.cellDelegate?.postUnliked(cellIndex: self.index)
            self.liked = false
            self.updateLikeCount(by: -1)
        }
    }
    
    @IBAction func showComments(_ sender: Any) {
        self.cellDelegate?.showComments(cellIndex: self.index)
    }
    
    @IBAction func share(_ sender: Any) {
        cellDelegate?.share(cellIndex: self.index)
    }
    
}

protocol PostTableViewCellDelegate {
    func postLiked(cellIndex: Int, showAnimation: Bool)
    func postUnliked(cellIndex: Int)
    func showComments(cellIndex: Int)
    func showProfile(cellIndex: Int)
    func share(cellIndex: Int)
}
