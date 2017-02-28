//
//  UserPicturesCollectionViewController.swift
//  Mich
//
//  Created by Gigi Pataraia on 9/30/16.
//  Copyright © 2016 Gigi. All rights reserved.
//

import UIKit
import Nuke

class UserPicturesCollectionViewController: SlidingMenuPresentingViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private let reuseIdentifier = "UserPicturesCollectionViewCell"
    let spaceing : CGFloat = 1.0
    let itemsPerRow : CGFloat = 3.0
    var imageSideLength : CGFloat = 0.0
    
    @IBOutlet weak var editOrFollow: UIButton!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var profileDetailsView: UIView!
    @IBOutlet weak var imageCollection: UICollectionView!
    
    @IBOutlet weak var followingButton: UIButton!
    @IBOutlet weak var followersButton: UIButton!
    
    var user: User? = nil
    var userId: Int! = -1
    var isOwner: Bool = false
    var posts: [PostClass] = []
    var isFollowing: Bool = false {
        didSet {
            if isFollowing {
                editOrFollow.setTitle("UNFOLLOW", for: .normal)
                editOrFollow.backgroundColor = UIColor.white
                editOrFollow.setTitleColor(UIColor.black, for: .normal)
            } else {
                editOrFollow.setTitle("FOLLOW", for: .normal)
                editOrFollow.setTitleColor(UIColor.white, for: .normal)
                editOrFollow.backgroundColor = UIColor(red: 255 / 255.0, green: 29.0 / 255, blue: 45.0 / 255, alpha: 1)
            }
        }
    }
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(UserPicturesCollectionViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        followersButton.titleLabel?.lineBreakMode = .byWordWrapping
        followersButton.titleLabel?.textAlignment = .center
        followersButton.setTitle("Followers", for: .normal)
        
        followingButton.titleLabel?.lineBreakMode = .byWordWrapping
        followingButton.titleLabel?.textAlignment = .center
        followingButton.setTitle("Following", for: .normal)
        
        currentIndex = 4
        if (self.userId == (UIApplication.shared.delegate as! AppDelegate).user?.id || self.userId == -1) {
            user = (UIApplication.shared.delegate as! AppDelegate).user
            self.navigationItem.title = user?.username
            self.userId = user?.id
            Nuke.loadImage(with: Foundation.URL(string: (user?.avatar)!)!, into: profilePicture)
            editOrFollow.setTitle("EDIT PROFILE", for: .normal)
            isOwner = true
            followersButton.setTitle(String((user?.nfollowers)! + 0) + "\nFollowers", for: .normal)
            followingButton.setTitle(String((user?.nfollowing)! + 0) + "\nFollowing", for: .normal)
        }
        else {
            editOrFollow.setTitle("FOLLOW", for: .normal)
            isOwner = false
            MichTransport.getuser(token: (UIApplication.shared.delegate as! AppDelegate).token!, id: self.userId,
                                successCallbackForgetuser: ongetusersuccess, errorCallbackForgetuser: onerror)
            MichTransport.isFollowing(token: (UIApplication.shared.delegate as! AppDelegate).token!, id: (self.userId)!,
                                successCallbackForIsFollowing: self.onsuccess, errorCallbackForIsFollowing: self.onerror)

        }
        imageSideLength = (self.view.frame.size.width - (itemsPerRow - 1) * spaceing)  / itemsPerRow
        profilePicture.image = profilePicture.image?.circle
        if #available(iOS 10.0, *) {
            self.imageCollection.refreshControl = refreshControl
        } else {
            self.imageCollection.addSubview(refreshControl)
        }
        MichTransport.getuserposts(token: (UIApplication.shared.delegate as! AppDelegate).token!, id: self.userId,
                        successCallbackForgetuserposts: ongetpostssuccess, errorCallbackForgetuserposts: onerror)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func editOrFollow(_ sender: Any) {
        if (isOwner) {
            performSegue(withIdentifier: "edit", sender: self)
        }
        else {
            if (isFollowing) {
                MichTransport.unfollow(token: (UIApplication.shared.delegate as! AppDelegate).token!, id: (user?.id)!,
                                       successCallbackForUnfollow: self.onunfollowsuccess, errorCallbackForUnfollow: self.onerror)
            }
            else {
                MichTransport.follow(token: (UIApplication.shared.delegate as! AppDelegate).token!, id: (user?.id)!,
                                     successCallbackForFollow: self.onfollowsuccess, errorCallbackForFollow: self.onerror)
            }
        }
    }
    // MARK: collectionview data source
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! UserPicturesCollectionViewCell
        Nuke.loadImage(with: Foundation.URL(string: posts[indexPath.item].image!)!, into: cell.photo)
        cell.post = posts[indexPath.item]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: imageSideLength, height: imageSideLength)
    }
    
    // MARK: callbacks
    func onunfollowsuccess () {
        self.isFollowing = false
        followersButton.setTitle(String((user?.nfollowers)! - 1) + "\nFollowers", for: .normal)
        user?.nfollowers = (user?.nfollowers)! - 1
    }
    
    func onfollowsuccess () {
        self.isFollowing = true
        followersButton.setTitle(String((user?.nfollowers)! + 1) + "\nFollowers", for: .normal)
        user?.nfollowers = (user?.nfollowers)! + 1
    }
    
    func onsuccess(resp: IsFollowingResponse) {
        isFollowing = resp.result!
    }
    
    func ongetpostssuccess(resp: [PostClass]) {
        self.posts.removeAll()
        self.posts.append(contentsOf: resp)
        self.imageCollection.reloadData()
        self.imageCollection.refreshControl?.endRefreshing()
    }
    
    func onerror(error: DefaultError){
        let alert = UIAlertController(title: "Alert", message: error.errorString, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func ongetusersuccess(user: User) {
        self.user = user
        self.navigationItem.title = user.username
        Nuke.loadImage(with: Foundation.URL(string: (user.avatar)!)!, into: profilePicture)
        followersButton.setTitle(String((user.nfollowers)! + 0) + "\nFollowers", for: .normal)
        followingButton.setTitle(String((user.nfollowing)! + 0) + "\nFollowing", for: .normal)
    }
    
    // MARK: refreshcontrol
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        MichTransport.getuserposts(token: (UIApplication.shared.delegate as! AppDelegate).token!, id: self.userId,
                        successCallbackForgetuserposts: ongetpostssuccess, errorCallbackForgetuserposts: onerror)
    }
    
    // MARK: navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if (segue.identifier == "followers" || segue.identifier == "following") {
            (segue.destination as! FollowViewController).user = self.user
            (segue.destination as! FollowViewController).ering = (segue.identifier == "followers")
        }
        else if segue.identifier == "showpost" {
            guard let vc = segue.destination as? PostViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let cell = sender as? UserPicturesCollectionViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            vc.post = cell.post
        }
    }
    @IBAction func unwindToProfilePage(sender: UIStoryboardSegue) {
        
    }
}
