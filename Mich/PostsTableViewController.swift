//
//  PostsTableViewController.swift
//  Mich
//
//  Created by Gigi Pataraia on 9/26/16.
//  Copyright © 2016 Gigi. All rights reserved.
//

import UIKit
import AMScrollingNavbar
import Nuke

class PostsTableViewController: UITableViewController, LikesListener {

    var posts = [PostClass]()
    var likeCnts = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        let imageName = "mich_navbar_logo"
        let logo = UIImage(named: imageName)
        let imageView = UIImageView(image: logo)
        self.navigationItem.titleView = imageView
       // self.tableView.rowHeight = UITableViewAutomaticDimension
        
        NotificationCenter.default.addObserver(self, selector: #selector(PostsTableViewController.showNotifications), name: NSNotification.Name(rawValue: "showNotifications"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PostsTableViewController.showMessages), name: NSNotification.Name(rawValue: "showMessages"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PostsTableViewController.showSettings), name: NSNotification.Name(rawValue: "showSettings"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PostsTableViewController.showHelp), name: NSNotification.Name(rawValue: "showHelp"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let navigationController = navigationController as? ScrollingNavigationController {
            navigationController.followScrollView(tableView, delay: 50.0)
        }
        MichTransport.getfeed(token: (UIApplication.shared.delegate as! AppDelegate).token!, successCallbackForgetfeed: onGetFeed, errorCallbackForgetfeed: onError);
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let navigationController = navigationController as? ScrollingNavigationController {
            navigationController.showNavbar(animated: false)
        }
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "disableScrolling"), object: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "PostTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PostTableViewCell
        Nuke.loadImage(with: Foundation.URL(string: posts[indexPath.row].image!)!, into: cell.postImage)
        cell.commentCount.text = "0"
        cell.likeCount.text = String(likeCnts[indexPath.row])
        cell.likeButton.tag = indexPath.row
        cell.index = indexPath.row
        let tap = UITapGestureRecognizer(target: cell, action: #selector(PostTableViewCell.postDoubleTapped))
        tap.numberOfTapsRequired = 2
        cell.postImage.addGestureRecognizer(tap)
        cell.likeDelegate = self
        cell.title.text = posts[indexPath.row].title
        return cell
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    //Mark: - AMScrolling navigation bar
    override func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        if let navigationController = navigationController as? ScrollingNavigationController {
            navigationController.showNavbar(animated: true)
        }
        return true
    }
    
    func postLiked(postIndex: Int, showAnimation: Bool) {
        likeCnts[postIndex] = likeCnts[postIndex] + 1
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
    
    func onGetFeed(resp: [PostClass]){
        posts.append(contentsOf: resp)
        for _ in 0 ..< resp.count {
            likeCnts.append(0)
        }
        self.tableView.reloadData()
    }
    
    
    
    func onError(error: DefaultError){
        
        let alert = UIAlertController(title: "Alert", message: error.errorString, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
}

extension PostsTableViewController {
    func showNotifications() {
        if (tabBarController?.selectedIndex == 0) {
            performSegue(withIdentifier: "notifications", sender: nil)
        }
    }
    func showMessages() {
        if (tabBarController?.selectedIndex == 0) {
            performSegue(withIdentifier: "messages", sender: nil)
        }
    }
    func showSettings() {
        if (tabBarController?.selectedIndex == 0) {
            performSegue(withIdentifier: "settings", sender: nil)
        }
    }
    func showHelp() {
        if (tabBarController?.selectedIndex == 0) {
            performSegue(withIdentifier: "help", sender: nil)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "enableScrolling"), object: nil)
    }
}
