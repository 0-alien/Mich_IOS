//
//  PostTableViewCell.swift
//  Mich
//
//  Created by Gigi Pataraia on 9/26/16.
//  Copyright © 2016 Gigi. All rights reserved.
//

import UIKit
import QuartzCore

class PostTableViewCell: UITableViewCell, UIScrollViewDelegate {
   
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentCount: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var createdAt: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var likeCountButton: UIButton!
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    
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

    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.postImage
    }

    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        //self.cellDelegate?.reloadSingleCell(cellIndex: self.index)
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .beginFromCurrentState, animations: {() -> Void in
            self.scrollView.setZoomScale(1.0, animated: false)
        }, completion: { _ in })
        
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    

    
    //like from double tap
    func postLiked() {
        if (!self.liked) {
            self.cellDelegate?.postLiked(cellIndex: self.index, showAnimation: true)
            self.liked = true
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
        }
        else {
            self.cellDelegate?.postUnliked(cellIndex: self.index)
            self.liked = false
        }
    }
    
    @IBAction func showComments(_ sender: Any) {
        self.cellDelegate?.showComments(cellIndex: self.index)
    }
    @IBAction func share(_ sender: Any) {
        cellDelegate?.share(cellIndex: self.index)
    }
    @IBAction func showLikers(_ sender: Any) {
         self.cellDelegate?.showLikes(cellIndex: self.index)
    }
}

protocol PostTableViewCellDelegate {
    func postLiked(cellIndex: Int, showAnimation: Bool)
    func postUnliked(cellIndex: Int)
    func showComments(cellIndex: Int)
    func showLikes(cellIndex: Int)
    func showProfile(cellIndex: Int)
    func share(cellIndex: Int)
    func reloadSingleCell(cellIndex: Int)
}
