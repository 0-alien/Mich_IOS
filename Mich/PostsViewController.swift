//
//  PostsViewController.swift
//  Mich
//
//  Created by Gigi Pataraia on 2/6/17.
//  Copyright © 2017 Gigi. All rights reserved.
//

import UIKit
import AMScrollingNavbar
import Nuke

class PostsViewController: SlidingMenuPresentingViewController, UITableViewDelegate, UITableViewDataSource, LikesListener {
    
    @IBOutlet weak var tableView: UITableView!
    var posts = [PostClass]()
    var destinationUserId: Int?
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
        currentIndex = 0
        if #available(iOS 10.0, *) {
            self.tableView.refreshControl = refreshControl
        } else {
            self.tableView.addSubview(refreshControl)
        }
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
        let cellIdentifier = "PostTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PostTableViewCell
        Nuke.loadImage(with: Foundation.URL(string: posts[indexPath.row].image!)!, into: cell.postImage)
        cell.likeButton.tag = indexPath.row
        cell.index = indexPath.row
        cell.likeCount.text = String(posts[indexPath.row].likeCnt!)
        cell.liked = (posts[indexPath.row].myLike == 1)
        
        let tap = UITapGestureRecognizer(target: cell, action: #selector(cell.postLiked))
        tap.numberOfTapsRequired = 2
        cell.postImage.addGestureRecognizer(tap)
        cell.likeDelegate = self
        cell.title.text = posts[indexPath.row].title
        
        let pictureTap = UITapGestureRecognizer(target: self, action: #selector(PostsViewController.userPictureTapped(_:)))
        pictureTap.numberOfTapsRequired = 1
        cell.userImage.addGestureRecognizer(pictureTap)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if (segue.identifier == "gotoprofilepage") {
            guard let vc = segue.destination as? UserPicturesCollectionViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            vc.userId = self.destinationUserId
        }
    }
    
    //Mark: actions
    //user picture tapped -> goto profile page of that user
    func userPictureTapped(_ sender: UITapGestureRecognizer) {
        if let indexPath = self.tableView.indexPathForRow(at: sender.location(in: tableView)) {
            self.destinationUserId = posts[indexPath.row].userId!
            performSegue(withIdentifier: "gotoprofilepage", sender: self)
        }
    }
    
    //likedelegate methods
    func postLiked(postIndex: Int, showAnimation: Bool) {
        posts[postIndex].likeCnt = posts[postIndex].likeCnt! + 1
        posts[postIndex].myLike = 1
        self.tableView.reloadRows(at: [IndexPath(row: postIndex, section: 0)], with: .none)
        if (showAnimation) {
            let cell = self.tableView.cellForRow(at: IndexPath(row: postIndex, section: 0)) as! PostTableViewCell
            let img = UIImageView(image: UIImage(named: "fire_icon"))
            let coef = cell.postImage.frame.size.width / 2.0 / img.frame.size.width
            img.frame = cell.postImage.frame.insetBy(dx: cell.postImage.frame.size.width / 4, dy: cell.postImage.frame.size.height / 2 - img.frame.size.height * coef / 2)
            cell.addSubview(img)
            UIView.animate(withDuration: 1, animations: {
                img.alpha = 0
            })
        }
        MichTransport.like(token: (UIApplication.shared.delegate as! AppDelegate).token!, postID: posts[postIndex].id!, successCallbackForLike: onLikeUnlikeSuccess, errorCallbackForLike: onError)
    }
    
    func postUnliked(postIndex: Int) {
        posts[postIndex].likeCnt = posts[postIndex].likeCnt! - 1
        posts[postIndex].myLike = 0
        self.tableView.reloadRows(at: [IndexPath(row: postIndex, section: 0)], with: .none)
        MichTransport.unlike(token: (UIApplication.shared.delegate as! AppDelegate).token!, postID: posts[postIndex].id!, successCallbackForUnlike: onLikeUnlikeSuccess, errorCallbackForUnlike: onError)
    }
    
    //Mark: server request callbacks
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
    
    
    //Mark: refresh
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        MichTransport.getfeed(token: (UIApplication.shared.delegate as! AppDelegate).token!, successCallbackForgetfeed: onGetFeed, errorCallbackForgetfeed: onError)
    }
}
