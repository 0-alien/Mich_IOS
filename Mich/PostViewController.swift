//
//  PostViewController.swift
//  Mich
//
//  Created by Gigi Pataraia on 2/28/17.
//  Copyright © 2017 Gigi. All rights reserved.
//

import UIKit
import Nuke

class PostViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postDate: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var postImage: UIImageView!
    var post: PostClass!
    var postId: Int!
    
    @IBOutlet weak var viewCommentsButton: UIButton!
    
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MichTransport.getpost(token: (UIApplication.shared.delegate as! AppDelegate).token!, id: postId,
                            successCallbackForgetpost: onGetPostSuccess, errorCallbackForgetpost: onGetPostError)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "showcomments" {
            (segue.destination as! CommentsViewController).postId = post.id
        }
    }
    
    func loadPost() {
        self.postTitle.text = self.post.title
        self.postDate.text = self.post.created_at
        self.userName.text = self.post.userName
        Nuke.loadImage(with: Foundation.URL(string: self.post.image!)!, into: self.postImage)
        Nuke.loadImage(with: Foundation.URL(string: self.post.avatar!)!, into: self.userImage)
        self.likeCountLabel.text = String(self.post.nLikes!)
        self.commentCountLabel.text = String(self.post.nComments!)
        if self.post.myLike == 1 {
            self.likeButton.backgroundColor = UIColor.red
        }
        if self.post.nComments == 0 {
            self.viewCommentsButton.isHidden = true
        }
        self.viewCommentsButton.titleLabel?.text = "View all " + String(self.post.nComments!) + " Comments"
    }
    
    // MARK: callbacks
    func onGetPostSuccess(resp: PostClass) {
        self.post = resp
        self.loadPost()
    }
    
    func onLikeSuccess() {
        self.post.myLike = 1
        self.post.nLikes = self.post.nLikes! + 1
        self.likeCountLabel.text = String(self.post.nLikes!)
        self.likeButton.backgroundColor = UIColor.red
    }
    
    func onUnlikeSuccess() {
        self.post.myLike = 0
        self.post.nLikes = self.post.nLikes! - 1
        self.likeCountLabel.text = String(self.post.nLikes!)
        self.likeButton.backgroundColor = UIColor.white
    }
    
    func onDoubleTapLikeSuccess() {
        self.onLikeSuccess()
        let img = UIImageView(image: UIImage(named: "fire_icon"))
        let coef = self.postImage.frame.size.width / 2.0 / img.frame.size.width
        img.frame = self.postImage.frame.insetBy(dx: self.postImage.frame.size.width / 4, dy: self.postImage.frame.size.height / 2.0 - img.frame.size.height * coef / 2.0)
        self.scrollView.addSubview(img)
        UIView.animate(withDuration: 1, animations: {
            img.alpha = 0
        })
    }
    
    func onGetPostError(error: DefaultError){
        let alert = UIAlertController(title: "Alert", message: error.errorString, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: actions
    @IBAction func like(_ sender: Any) {
        if post.myLike == 1 {
            MichTransport.unlike(token: (UIApplication.shared.delegate as! AppDelegate).token!, postID: self.postId, successCallbackForUnlike: onUnlikeSuccess, errorCallbackForUnlike: onGetPostError)
        }
        else {
            MichTransport.like(token: (UIApplication.shared.delegate as! AppDelegate).token!, postID: self.postId, successCallbackForLike: onLikeSuccess, errorCallbackForLike: onGetPostError)
        }
    }
    @IBAction func doubleTapLike(_ sender: Any) {
        if self.post.myLike == 1 {
            return
        }
        MichTransport.like(token: (UIApplication.shared.delegate as! AppDelegate).token!, postID: self.postId, successCallbackForLike: onDoubleTapLikeSuccess, errorCallbackForLike: onGetPostError)
    }
    
}
