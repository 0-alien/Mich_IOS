//
//  CommentsTableViewCell.swift
//  Mich
//
//  Created by Gigi Pataraia on 11/15/16.
//  Copyright © 2016 Gigi. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {


    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var data: UILabel!
    @IBOutlet weak var ratingImage: UIImageView!
    var commentId: Int!
    var delegate: CommentDelegate!
    
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
    
    func setRating(_ rating: Int) {
        assert(rating >= 1 && rating < 6);
        self.ratingImage.image = UIImage(named: "rating-" + String(rating))
    }
    
    @IBAction func like(_ sender: Any) {
        if self.liked! {
            //unlike
            self.liked = false
            self.delegate.onCommentUnlike(commentId: self.commentId)
        }
        else {
            //like
            self.liked = true
            self.delegate.onCommentLike(commentId: self.commentId)
        }
    }
  
}

protocol CommentDelegate {
    func onCommentLike(commentId: Int)
    func onCommentUnlike(commentId: Int)
}


