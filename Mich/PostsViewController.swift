//
//  PostsViewController.swift
//  Mich
//
//  Created by Gigi Pataraia on 2/6/17.
//  Copyright © 2017 Gigi. All rights reserved.
//

import UIKit
import Nuke
import Social
import QuartzCore

class PostsViewController: SlidingMenuPresentingViewController, UITableViewDelegate, UITableViewDataSource, PostTableViewCellDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    var posts = [PostClass]()
    var destinationUserId: Int?
    var destinationPostId: Int?
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(PostsViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        return refreshControl
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageName = "mich_navbar_logo"
        let logo = UIImage(named: imageName)
        let imageView = UIImageView(image: logo)
        self.navigationItem.titleView = imageView
        if #available(iOS 10.0, *) {
            self.tableView.refreshControl = refreshControl
        } else {
            self.tableView.addSubview(refreshControl)
        }
        currentIndex = 0
        MichTransport.getfeed(token: (UIApplication.shared.delegate as! AppDelegate).token!, successCallbackForgetfeed: onGetFeed, errorCallbackForgetfeed: onError)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "disableScrolling"), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        let cellIdentifier = "PostTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PostTableViewCell
        Nuke.loadImage(with: Foundation.URL(string: post.image!)!, into: cell.postImage)
        Nuke.loadImage(with: Foundation.URL(string: post.avatar!)!, into: cell.userImage)
        cell.commentCount.text = String(post.nComments!)
        cell.liked = (post.myLike == 1)
        cell.index = indexPath.row
        cell.createdAt.text = post.created_at
        cell.userName.text = post.userName
        cell.userImage = cell.userImage.circle
        
        cell.scrollView.delegate = cell
        cell.clipsToBounds = false
        cell.scrollView.minimumZoomScale = 1.0
        cell.scrollView.maximumZoomScale = 6.0
        
        let tap = UITapGestureRecognizer(target: cell, action: #selector(cell.postLiked))
        tap.numberOfTapsRequired = 2
        cell.postImage.addGestureRecognizer(tap)
        
        let profilePictureTap = UITapGestureRecognizer(target: cell, action: #selector(cell.showProfile))
        profilePictureTap.numberOfTapsRequired = 1
        cell.userImage.addGestureRecognizer(profilePictureTap)
        let userImageTap = UITapGestureRecognizer(target: cell, action: #selector(cell.showProfile))
        userImageTap.numberOfTapsRequired = 1
        cell.userName.addGestureRecognizer(userImageTap)
        
        cell.cellDelegate = self
        cell.title.text = post.title
        
        if post.nLikes == 0 {
            cell.likeCountButton.isHidden = true
        }
        else if post.nLikes == 1 {
            cell.likeCountButton.isHidden = false
            cell.likeCountButton.setTitle("1 Like", for: .normal)
        }
        else {
            cell.likeCountButton.isHidden = false
            cell.likeCountButton.setTitle(String(0 + post.nLikes!) + " Likes", for: .normal)
        }
        
        return cell
    }
    // MARK: navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if (segue.identifier == "gotoprofilepage") {
            guard let vc = segue.destination as? UserPicturesCollectionViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            vc.hidesBottomBarWhenPushed = true
            vc.userId = self.destinationUserId
        }
        else if segue.identifier == "showcomments" {
            guard let vc = segue.destination as? CommentsViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            vc.postId = self.destinationPostId
        }
        else if segue.identifier == "showlikes" {
            // TODO
        }
    }
    
    // MARK:  celldelegate methods
    func postLiked(cellIndex: Int, showAnimation: Bool) {
        posts[cellIndex].nLikes = posts[cellIndex].nLikes! + 1
        posts[cellIndex].myLike = 1
        self.tableView.reloadRows(at: [IndexPath(row: cellIndex, section: 0)], with: .none)
        if (showAnimation) {
            let cell = self.tableView.cellForRow(at: IndexPath(row: cellIndex, section: 0)) as! PostTableViewCell
            let img = UIImageView(image: UIImage(named: "fire_icon"))
            let coef = cell.postImage.frame.size.width / 2.0 / img.frame.size.width
            img.frame = cell.postImage.frame.insetBy(dx: cell.postImage.frame.size.width / 4, dy: cell.postImage.frame.size.height / 2 - img.frame.size.height * coef / 2)
            cell.scrollView.addSubview(img)
            UIView.animate(withDuration: 1, animations: {
                img.alpha = 0
            })
        }
        MichTransport.like(token: (UIApplication.shared.delegate as! AppDelegate).token!, postID: posts[cellIndex].id!, successCallbackForLike: onLikeUnlikeSuccess, errorCallbackForLike: onError)
    }
    
    func reloadSingleCell(cellIndex: Int) {
        self.tableView.reloadRows(at: [IndexPath(row: cellIndex, section: 0)], with: .none)
    }
    
    func postUnliked(cellIndex: Int) {
        posts[cellIndex].nLikes = posts[cellIndex].nLikes! - 1
        posts[cellIndex].myLike = 0
        self.tableView.reloadRows(at: [IndexPath(row: cellIndex, section: 0)], with: .none)
        MichTransport.unlike(token: (UIApplication.shared.delegate as! AppDelegate).token!, postID: posts[cellIndex].id!, successCallbackForUnlike: onLikeUnlikeSuccess, errorCallbackForUnlike: onError)
    }
    func showProfile(cellIndex: Int) {
        self.destinationUserId = self.posts[cellIndex].userId
        performSegue(withIdentifier: "gotoprofilepage", sender: self)
    }
    
    func showComments(cellIndex: Int) {
        self.destinationPostId = self.posts[cellIndex].id
        performSegue(withIdentifier: "showcomments", sender: self)
    }
    
    func showLikes(cellIndex: Int) {
        self.destinationPostId = self.posts[cellIndex].id
        performSegue(withIdentifier: "showlikes", sender: self)
    }
    
    // MARK: share
    func share(cellIndex: Int) {
        
       
        let alert = UIAlertController()
        
        let sharePhoto = UIAlertAction(title: "Share photo with facebook", style: .default, handler: { ACTION in
            let shareToFacebook: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            
            shareToFacebook.add(Foundation.URL(string:self.posts[cellIndex].image!))
            
            self.present(shareToFacebook, animated: true, completion: nil)
        })
        
        let shareContent = UIAlertAction(title: "Share content with facebook", style: .default, handler: { ACTION in
            MichTransport.socialShare(token: (UIApplication.shared.delegate as! AppDelegate).token!, postID: self.posts[cellIndex].id!, successCallbackForSocialShare: self.onsuccessSocialShare, errorCallbackForSocialShare: self.onError)
            
        })
        
        
        if(posts[cellIndex].userId == (UIApplication.shared.delegate as! AppDelegate).user?.id){
        
            let deletePost = UIAlertAction(title: "Delete post", style: .destructive, handler: { ACTION in
                MichTransport.deletepost(token: (UIApplication.shared.delegate as! AppDelegate).token!, postID: self.posts[cellIndex].id!, successCallbackForDeletePost: self.onsuccessDelete, errorCallbackForDeletePost: self.onErrorDelete)
            
            })
            alert.addAction(deletePost)
       
        }else{
        
            let hidePost = UIAlertAction(title: "Hide post", style: .default, handler: { ACTION in
            
                MichTransport.hidepost(token: (UIApplication.shared.delegate as! AppDelegate).token!, postID: self.posts[cellIndex].id!, successCallbackForHidePost: self.onsuccessHide, errorCallbackForHidePost: self.onErrorDelete)
                
            })
            alert.addAction(hidePost)
        }
        
        
        
        alert.addAction(sharePhoto)
        alert.addAction(shareContent)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel,handler: nil))
        
        self.present(alert, animated: true, completion: nil)

        
        
        
        
    }
    
    
    func onsuccessSocialShare(socialShareResponse: SocialResponse){
        let shareToFacebook: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        shareToFacebook.add(Foundation.URL(string:socialShareResponse.url!))
        
        self.present(shareToFacebook, animated: true, completion: nil)
        print(socialShareResponse.url ?? "")
        
    }
    
    
    func onsuccessHide(postId: Int){
        for i in 0 ..< posts.count {
            if posts[i].id == postId {
                posts.remove(at: i)
                break
            }
        }
        self.tableView.reloadData()
    }
    
    
    func onsuccessDelete(postId: Int){
        for i in 0 ..< posts.count {
            if posts[i].id == postId {
                posts.remove(at: i)
                break
            }
        }
        self.tableView.reloadData()
    }
    

    func onErrorDelete(error: DefaultError){
        let alert = UIAlertController(title: "Alert", message: error.errorString, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    // MARK: server request callbacks
    func onGetFeed(resp: [PostClass]){
        posts.removeAll()
        posts.append(contentsOf: resp)
        self.tableView.reloadData()
        self.tableView.refreshControl?.endRefreshing()
    }

    func onLikeUnlikeSuccess() {
        //Nothing
    }
    
    func onError(error: DefaultError){
        let alert = UIAlertController(title: "Alert", message: error.errorString, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: refreshcontrol
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        MichTransport.getfeed(token: (UIApplication.shared.delegate as! AppDelegate).token!, successCallbackForgetfeed: onGetFeed, errorCallbackForgetfeed: onError)
    }
}
