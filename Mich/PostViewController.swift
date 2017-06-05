//
//  PostViewController.swift
//  Mich
//
//  Created by Gigi Pataraia on 2/28/17.
//  Copyright © 2017 Gigi. All rights reserved.
//

import UIKit
import Nuke
import Social


class PostViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postDate: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var postImage: UIImageView!
    
    var postId: Int!
    var destinationCommentId: Int! = nil // in case of comment added/liked notification
    var needsToShowComments: Bool! = false // same
    
    @IBOutlet weak var zoomingScrollView: UIScrollView!
    
    @IBOutlet var mainView: UIView!

    var post: PostClass!
    var refreshControl: UIRefreshControl!
    
    
    @IBOutlet weak var viewCommentsButton: UIButton!
    
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    
    var widthOfZoomScrollView:CGFloat!
    var heightOfZoomScrollView:CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(PostViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        if #available(iOS 10.0, *) {
            self.scrollView.refreshControl = refreshControl
        } else {
            self.scrollView.addSubview(refreshControl)
        }
        MichTransport.getpost(token: (UIApplication.shared.delegate as! AppDelegate).token!, id: postId,
                            successCallbackForgetpost: onGetPostSuccess, errorCallbackForgetpost: onGetPostError)
        self.zoomingScrollView.minimumZoomScale = 1.0
        self.zoomingScrollView.maximumZoomScale = 6.0
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if needsToShowComments {
            self.needsToShowComments = false
            performSegue(withIdentifier: "showcommentnotification", sender: self)
            self.destinationCommentId = -1
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "showcomments" {
            (segue.destination as! CommentsViewController).postId = post.id
        }
        else if segue.identifier == "gotoprofilepage" {
            (segue.destination as! UserPicturesCollectionViewController).userId = self.post.userId
        }
        else if segue.identifier == "showcommentnotification" {
            (segue.destination as! CommentsViewController).postId = self.postId
            (segue.destination as! CommentsViewController).needsToShowComment = true
            (segue.destination as! CommentsViewController).destinationCommentId = self.destinationCommentId
        }
    }
    
    // MARK: zooming
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.postImage
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        self.navigationController?.navigationBar.layer.zPosition = -1
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {

        UIView.animate(withDuration: 0.5, delay: 0, options: .beginFromCurrentState, animations: {() -> Void in
            self.zoomingScrollView.setZoomScale(1.0, animated: false)
        }, completion: { _ in self.navigationController?.navigationBar.layer.zPosition = 0 })
        
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
            self.likeButton.setImage(UIImage(named: "liked_icon"), for: .normal)
        }
        if self.post.nComments == 0 {
            self.viewCommentsButton.isHidden = true
        }
        self.viewCommentsButton.setTitle("View all " + String(self.post.nComments!) + " Comments", for: .normal)
    }
    
    // MARK: callbacks
    func onGetPostSuccess(resp: PostClass) {
        refreshControl.endRefreshing()
        self.post = resp
        self.loadPost()
    }
    
    func onLikeSuccess() {
        self.post.myLike = 1
        self.post.nLikes = self.post.nLikes! + 1
        self.likeCountLabel.text = String(self.post.nLikes!)
        self.likeButton.setImage(UIImage(named: "liked_icon"), for: .normal)
    }
    
    func onUnlikeSuccess() {
        self.post.myLike = 0
        self.post.nLikes = self.post.nLikes! - 1
        self.likeCountLabel.text = String(self.post.nLikes!)
        self.likeButton.setImage(UIImage(named: "like_icon"), for: .normal)
    }
    
    func onDoubleTapLikeSuccess() {
        self.onLikeSuccess()
        let img = UIImageView(image: UIImage(named: "fire_icon"))
        let coef = self.postImage.frame.size.width / 2.0 / img.frame.size.width
        img.frame = self.postImage.frame.insetBy(dx: self.postImage.frame.size.width / 4, dy: self.postImage.frame.size.height / 2.0 - img.frame.size.height * coef / 2.0)
        self.zoomingScrollView.addSubview(img)
        UIView.animate(withDuration: 1, animations: {
            img.alpha = 0
        })
    }
    
    func onGetPostError(error: DefaultError){
        refreshControl.endRefreshing()
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
    
    @IBAction func profilePictureTapped(_ sender: Any) {
        performSegue(withIdentifier: "gotoprofilepage", sender: self)
    }
    
    @IBAction func edit(_ sender: Any) {
        let alert = UIAlertController()
        
        let sharePhoto = UIAlertAction(title: "Share photo with facebook", style: .default, handler: { ACTION in
            let shareToFacebook: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            
            
            shareToFacebook.add(Foundation.URL(string:self.post.image!))
            
            self.present(shareToFacebook, animated: true, completion: nil)
        })
        
        let shareContent = UIAlertAction(title: "Share content with facebook", style: .default, handler: { ACTION in
            MichTransport.socialShare(token: (UIApplication.shared.delegate as! AppDelegate).token!, postID: self.post.id!, successCallbackForSocialShare: self.onsuccessSocialShare, errorCallbackForSocialShare: self.onError)

            
        })
        
        if(post.userId == (UIApplication.shared.delegate as! AppDelegate).user?.id){
            let delete = UIAlertAction(title: "Delete", style: .destructive, handler: { ACTION in
           
                MichTransport.deletepost(token: (UIApplication.shared.delegate as! AppDelegate).token!, postID: self.post.id!, successCallbackForDeletePost: self.onsuccessDelete, errorCallbackForDeletePost: self.onError)
            
            })
            alert.addAction(delete)
        
        }else{
            
            let reportPost = UIAlertAction(title: "Report Post", style: .destructive, handler: { ACTION in
                
                MichTransport.reportpost(token: (UIApplication.shared.delegate as! AppDelegate).token!, postID: self.post.id!, successCallbackForReportPost: self.onsuccessReport, errorCallbackForReportPost: self.onError)
                
            })
            alert.addAction(reportPost)
            
        }
        
        alert.addAction(sharePhoto)
        alert.addAction(shareContent)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel,handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func onsuccessReport(){
        let alert = UIAlertController(title: "Alert", message: "Post Reported", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    func onsuccessSocialShare(socialShareResponse: SocialResponse){
        let shareToFacebook: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        shareToFacebook.add(Foundation.URL(string:socialShareResponse.url!))
        
        self.present(shareToFacebook, animated: true, completion: nil)
        
        
        print(socialShareResponse.url ?? "")
        
    }

    func onsuccessDelete(postId: Int){
        performSegue(withIdentifier: "unwindfrompostpage", sender: self)
    }
    
    
    func onError(error: DefaultError){
        let alert = UIAlertController(title: "Alert", message: error.errorString, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: refreshcontrol
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        MichTransport.getpost(token: (UIApplication.shared.delegate as! AppDelegate).token!, id: postId,
                successCallbackForgetpost: onGetPostSuccess, errorCallbackForgetpost: onGetPostError)
    }
    
}
