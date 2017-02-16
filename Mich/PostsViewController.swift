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
    var destinationUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageName = "mich_navbar_logo"
        let logo = UIImage(named: imageName)
        let imageView = UIImageView(image: logo)
        self.navigationItem.titleView = imageView
        currentIndex = 0
        // self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let navigationController = navigationController as? ScrollingNavigationController {
            navigationController.followScrollView(tableView, delay: 50.0)
        }
        MichTransport.getfeed(token: (UIApplication.shared.delegate as! AppDelegate).token!, successCallbackForgetfeed: onGetFeed, errorCallbackForgetfeed: onError)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let navigationController = navigationController as? ScrollingNavigationController {
            navigationController.showNavbar(animated: false)
        }
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
        //cell.commentCount.text = "0"
        //cell.likeCount.text = String(posts[indexPath.row].likeCnt!)
        cell.likeButton.tag = indexPath.row
        cell.index = indexPath.row
        
        let tap = UITapGestureRecognizer(target: cell, action: #selector(PostTableViewCell.postDoubleTapped))
        tap.numberOfTapsRequired = 2
        cell.postImage.addGestureRecognizer(tap)
        cell.likeDelegate = self
        cell.title.text = posts[indexPath.row].title
        
        let pictureTap = UITapGestureRecognizer(target: self, action: #selector(PostsTableViewController.userPictureTapped(_:)))
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
            vc.user = self.destinationUser
        }
    }
    
    //Mark: - AMScrolling navigation bar
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        if let navigationController = navigationController as? ScrollingNavigationController {
            navigationController.showNavbar(animated: true)
        }
        navigationController?.setNavigationBarHidden(false, animated: true)
        return true
    }
    
    //Mark: actions
    func userPictureTapped(_ sender: UITapGestureRecognizer) {
        if let indexPath = self.tableView.indexPathForRow(at: sender.location(in: tableView)) {
            let userId: Int = posts[indexPath.row].userId!
            MichTransport.getuser(token: (UIApplication.shared.delegate as! AppDelegate).token!, id: userId, successCallbackForgetuser: self.onGetUser,
                                  errorCallbackForgetuser: self.onError)
        }
    }
    
    
    func postLiked(postIndex: Int, showAnimation: Bool) {
        posts[postIndex].likeCnt = posts[postIndex].likeCnt! + 1
        self.tableView.reloadRows(at: [IndexPath(row: postIndex, section: 0)], with: .none)
        if (showAnimation) {
            let cell = self.tableView.cellForRow(at: IndexPath(row: postIndex, section: 0)) as! PostTableViewCell
            let img = UIImageView(image: UIImage(named: "fire_icon"))
            let coef = cell.frame.size.width / 2.0 / img.frame.size.width
            img.frame = cell.frame.insetBy(dx: cell.frame.size.width / 4, dy: cell.frame.size.height / 2 - img.frame.size.height * coef / 2)
            self.view.addSubview(img)
            UIView.animate(withDuration: 1, animations: {
                img.alpha = 0
            })
        }
    }
    
    
    //Mark: server request callbacks
    func onGetFeed(resp: [PostClass]){
        posts.removeAll()
        posts.append(contentsOf: resp)
        self.tableView.reloadData()
    }
    
    func onGetUser(resp: User) {
        self.destinationUser = resp
        performSegue(withIdentifier: "gotoprofilepage", sender: self)
    }
    
    
    func onError(error: DefaultError){
        
        let alert = UIAlertController(title: "Alert", message: error.errorString, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
}
