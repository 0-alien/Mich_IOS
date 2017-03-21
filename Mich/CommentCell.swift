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
    @IBOutlet weak var ratingImage: UIImageView!
    var commentIndex: Int!
    var delegate: CommentDelegate!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var editCommentButton: UIButton!
    
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setLikeCount(count: Int) {
        assert(count >= 0);
        self.likeCountLabel.text = String(count)
        if count == 0 {
            self.ratingImage.image = nil
            self.ratingImage.backgroundColor = UIColor.cyan
        }
        else {
            self.ratingImage.image = UIImage(named: "rating-" + String(Swift.min(5, count)))
        }
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


