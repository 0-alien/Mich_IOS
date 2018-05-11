//
//  CommentsTableViewCell.swift
//  Mich
//
//  Created by Gigi Pataraia on 11/15/16.
//  Copyright © 2016 Gigi. All rights reserved.
//

import UIKit
import Swift

class CommentCell: UITableViewCell {


    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var data: UILabel!
    var commentIndex: Int!
    var delegate: CommentDelegate!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var editCommentButton: UIButton!
    @IBOutlet weak var userName: UILabel!
    
    var liked: Bool! {
        didSet {
            if liked! {
                likeButton.setTitle("Unlike", for: .normal)
            }
            else {
                likeButton.setTitle("Like", for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setLikeCount(count: Int) {
        assert(count >= 0);
        self.likeCountLabel.text = String(count)
    }
    
    @IBAction func like(_ sender: Any) {
        if self.liked! {
            //unlike
            self.delegate.onCommentUnlike(commentIndex: self.commentIndex)
        }
        else {
            //like
            self.delegate.onCommentLike(commentIndex: self.commentIndex)
        }
    }
    @IBAction func editComment(_ sender: Any) {
        delegate.onEditComment(commentIndex: self.commentIndex)
    }
  
}

protocol CommentDelegate {
    func onCommentLike(commentIndex: Int)
    func onCommentUnlike(commentIndex: Int)
    func onEditComment(commentIndex: Int)
}


