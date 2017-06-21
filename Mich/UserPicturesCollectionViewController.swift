//
//  UserPicturesCollectionViewController.swift
//  Mich
//
//  Created by Gigi Pataraia on 9/30/16.
//  Copyright © 2016 Gigi. All rights reserved.
//

import UIKit
import Nuke
import AlamofireImage

class UserPicturesCollectionViewController: SlidingMenuPresentingViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {

    private let reuseIdentifier = "UserPicturesCollectionViewCell"
    let spaceing : CGFloat = 1.0
    let itemsPerRow : CGFloat = 3.0
    var imageSideLength : CGFloat = 0.0
    var tmpImage: UIImage!
    var changeProfilePicture: Bool! = false //imagepickercontroller helper flag
    
    @IBOutlet weak var editOrFollow: UIButton!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var profileDetailsView: UIView!
    @IBOutlet weak var imageCollection: UICollectionView!
    
    @IBOutlet weak var followingButton: UIButton!
    @IBOutlet weak var followersButton: UIButton!
    
    var destinationCommentId: Int! = nil // in case of comment added/liked notification
    var destinationPostId: Int! = nil // same 
    
    var refreshControl: UIRefreshControl!
    
    private var user: User? = nil
    var userId: Int! = -1
    var isOwner: Bool = false
    var posts: [PostClass] = []
    var canVs: Bool = true {
        didSet {
            navigationItem.rightBarButtonItem?.isEnabled = canVs
        }
    }
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        followersButton.titleLabel?.lineBreakMode = .byWordWrapping
        followersButton.titleLabel?.textAlignment = .center
        followersButton.setTitle("Followers", for: .normal)
        
        followingButton.titleLabel?.lineBreakMode = .byWordWrapping
        followingButton.titleLabel?.textAlignment = .center
        followingButton.setTitle("Following", for: .normal)
        
        self.profilePicture = self.profilePicture.borderedCircle
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
            self.navigationItem.rightBarButtonItem = nil
        }
        else {
            self.canVs = true
            editOrFollow.setTitle("FOLLOW", for: .normal)
            isOwner = false
            self.profilePicture.isUserInteractionEnabled = false
            MichTransport.getuser(token: (UIApplication.shared.delegate as! AppDelegate).token!, id: self.userId,
                                successCallbackForgetuser: ongetusersuccess, errorCallbackForgetuser: onerror)
            MichTransport.isFollowing(token: (UIApplication.shared.delegate as! AppDelegate).token!, id: (self.userId)!,
                                successCallbackForIsFollowing: self.onsuccess, errorCallbackForIsFollowing: self.onerror)
        }
        imageSideLength = (self.view.frame.size.width - (itemsPerRow - 1) * spaceing)  / itemsPerRow
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(UserPicturesCollectionViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
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
        cell.photo.af_setImage(withURL: Foundation.URL(string: posts[indexPath.item].image!)!)
        //Nuke.loadImage(with: Foundation.URL(string: posts[indexPath.item].image!)!, into: cell.photo)
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
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.refreshControl.endRefreshing()
        })
    }
    
    func onerror(error: DefaultError){
        let alert = UIAlertController(title: "Alert", message: error.errorString, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        self.refreshControl.endRefreshing()
    }
    
    func ongetusersuccess(user: User) {
        self.user = user
        self.navigationItem.title = user.username
        Nuke.loadImage(with: Foundation.URL(string: (user.avatar)!)!, into: profilePicture)
        followersButton.setTitle(String((user.nfollowers)! + 0) + "\nFollowers", for: .normal)
        followingButton.setTitle(String((user.nfollowing)! + 0) + "\nFollowing", for: .normal)
    }
    
    func onInviteSuccess() {
        print("success invite")
        self.canVs = false
    }
    
    func onUpdateProfilePicture(resp: User) {
        self.profilePicture.image = tmpImage
        self.user = resp
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
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            let indexPath = imageCollection.indexPath(for: cell)
            vc.postId = posts[(indexPath?.item)!].id
        }
        else if segue.identifier == "showpostnotification" {
            guard let vc = segue.destination as? PostViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            vc.postId = sender as! Int
        }
        else if segue.identifier == "showcommentnotification" {
            guard let vc = segue.destination as? PostViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            vc.postId = (sender as! UserPicturesCollectionViewController).destinationPostId
            vc.destinationCommentId = (sender as! UserPicturesCollectionViewController).destinationCommentId
            vc.needsToShowComments = true
        }
        else if segue.identifier == "edit" {
            guard let vc = (segue.destination as? UINavigationController)?.viewControllers[0] as? EditProfileViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            vc.user = self.user
        }
    }
    
    // MARK: actions
    @IBAction func unwindToProfilePage(sender: UIStoryboardSegue) {
        MichTransport.getuser(token: (UIApplication.shared.delegate as! AppDelegate).token!, id: self.userId,
                        successCallbackForgetuser: ongetusersuccess, errorCallbackForgetuser: onerror)
    }
    @IBAction func vs(_ sender: Any) {
        MichVSTransport.invite(token: (UIApplication.shared.delegate as! AppDelegate).token!, id: self.userId, successCallbackForinvite: onInviteSuccess, errorCallbackForinvite: onerror)
    }
    
    @IBAction func unwindFromPostPage(sender: UIStoryboardSegue) {
        let postId = (sender.source as! PostViewController).postId
        for i in 0 ..< self.posts.count {
            if self.posts[i].id == postId {
                self.posts.remove(at: i)
                break
            }
        }
        self.imageCollection.reloadData()
    }
    override func camera(_ sender: AnyObject) {
        if self.changeProfilePicture {
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        else {
            super.camera(sender)
        }
    }
    
    override func libr(_ sender: AnyObject) {
        if self.changeProfilePicture {
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        else {
            super.libr(sender)
        }
    }
    
    
    @IBAction func profileAction(_ sender: Any) {
        let alert = UIAlertController()
        
        
        if(!(user?.blocked)!){
            let blockUser = UIAlertAction(title: "block", style: .destructive, handler: { ACTION in
                MichTransport.blockuser(token: (UIApplication.shared.delegate as! AppDelegate).token!, userID: self.userId,
                                         successCallbackForBlockUser: self.onblockusersuccess, errorCallbackForBlockUser: self.onerror)
            })
            alert.addAction(blockUser)
        }else{
        
            let unblockUser = UIAlertAction(title: "unblock", style: .default, handler: { ACTION in
                MichTransport.unblockuser(token: (UIApplication.shared.delegate as! AppDelegate).token!, userID: self.userId,
                                        successCallbackForUnBlockUser: self.onrunblockusersuccess, errorCallbackForUnBlockUser: self.onerror)
            })
            alert.addAction(unblockUser)
        }
        
        let reportUser = UIAlertAction(title: "report", style: .destructive, handler: { ACTION in
            MichTransport.reportuser(token: (UIApplication.shared.delegate as! AppDelegate).token!, userID: self.userId,
                                  successCallbackForReportUser: self.onreportusersuccess, errorCallbackForReportUser: self.onerror)
        })
        
        
        
        alert.addAction(reportUser)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default,handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    

    func onreportusersuccess() {
        print("reported user")
        
    }
    
    
    func onblockusersuccess() {
        user?.blocked = true
        
    }
    
    
    func onrunblockusersuccess() {
        user?.blocked = false
        
    }
    
    
    
    @IBAction func changeProfilePicture(_ sender: Any) {
        self.changeProfilePicture = true
        let alert = UIAlertController()
        let takePicture = UIAlertAction(title: "Take Picture", style: .default, handler: { ACTION in
            self.camera(sender as AnyObject)
        })
        let library = UIAlertAction(title: "Choose from library", style: .default, handler: { ACTION in
            self.libr(sender as AnyObject)
        })
        alert.addAction(takePicture)
        alert.addAction(library)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel,handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.changeProfilePicture = false
        self.dismiss(animated: true, completion: nil)
    }
    
    override func imagePickerController(_ picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!){
        if self.changeProfilePicture {
            self.changeProfilePicture = false
            tmpImage = image
            self.dismiss(animated: true, completion: nil)
            MichTransport.updateUser(token: (UIApplication.shared.delegate as! AppDelegate).token!, name: user?.username, email: user?.email, avatar: tmpImage, successCallbackForUpdateUser: onUpdateProfilePicture, errorCallbackForUpdateUser: onerror)
        }
        else {
            super.imagePickerController(picker, didFinishPickingImage: image, editingInfo: editingInfo)
        }
    }
}
