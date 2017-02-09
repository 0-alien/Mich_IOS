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
    var user: User? = nil
    var isOwner: Bool = false
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
        currentIndex = 4
        
        if (user == nil) {
            user = (UIApplication.shared.delegate as! AppDelegate).user
        }
        Nuke.loadImage(with: Foundation.URL(string: (user?.avatar)!)!, into: profilePicture)
        self.navigationItem.title = user?.username
        if (user?.id == (UIApplication.shared.delegate as! AppDelegate).user?.id) {
            editOrFollow.setTitle("EDIT PROFILE", for: .normal)
            isOwner = true
        }
        else {
            editOrFollow.setTitle("FOLLOW", for: .normal)
            isOwner = false
            MichTransport.isFollowing(token: (UIApplication.shared.delegate as! AppDelegate).token!, id: (user?.id!)!,
                                      successCallbackForIsFollowing: self.onsuccess, errorCallbackForIsFollowing: self.onerror)

        }
        imageSideLength = (self.view.frame.size.width - (itemsPerRow - 1) * spaceing)  / itemsPerRow
        profilePicture.image = profilePicture.image?.circle
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: UICollectionViewDataSource

     func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    @IBAction func editOrFollow(_ sender: Any) {
        if (isOwner) {
            performSegue(withIdentifier: "edit", sender: self)
        }
        else {
            if (isFollowing) {
                MichTransport.unfollow(token: (UIApplication.shared.delegate as! AppDelegate).token!, id: (user?.id)!,
                                       successCallbackForUnfollow: self.onunfollowsuccess, errorCallbackForUnfollow: self.onerror)
                print("unfollow")
            }
            else {
                MichTransport.follow(token: (UIApplication.shared.delegate as! AppDelegate).token!, id: (user?.id)!,
                                     successCallbackForFollow: self.onfollowsuccess, errorCallbackForFollow: self.onerror)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return (user?.posts?.count)!
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! UserPicturesCollectionViewCell
        Nuke.loadImage(with: Foundation.URL(string: (user?.posts?[indexPath.item].image!)!)!, into: cell.photo)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: imageSideLength, height: imageSideLength)
    }
    
    @IBAction func unwindToProfilePage(sender: UIStoryboardSegue) {
        
    }
    
    //Mark: callbacks
    func onunfollowsuccess () {
        self.isFollowing = false
    }
    
    func onfollowsuccess () {
        self.isFollowing = true
    }
    
    func onsuccess(resp: IsFollowingResponse) {
        isFollowing = resp.result!
    }
    
    func onerror(error: DefaultError){
        
        let alert = UIAlertController(title: "Alert", message: error.errorString, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
}
