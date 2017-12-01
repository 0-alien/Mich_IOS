//
//  MichSwipePhotosViewController.swift
//  Mich
//
//  Created by zuraba on 9/4/17.
//  Copyright © 2017 Lemon. All rights reserved.
//

import UIKit
import Nuke
import XLPagerTabStrip

class MichSwipePhotosViewController: SlidingMenuPresentingViewController, IndicatorInfoProvider {

    @IBOutlet weak var viewOfPhoto: UIView!
    @IBOutlet weak var randomImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var tittle: UILabel!
    var postRandom: PostClass!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.currentIndex = 6
        MichTransport.getrandompost(token: (UIApplication.shared.delegate as! AppDelegate).token!, successCallbackGetRandomPost: onSuccessGetRandomPost, errorCallbackGetRandomPost: onerror)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - inidcator info provider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Shuffle")
    }
    
    // MARK: - actions
    @IBAction func LikePhoto(_ sender: Any) {
      
        self.performSegue(withIdentifier: "showpost", sender: self)
        UIView.animate(withDuration: 0.6, animations: {
            self.viewOfPhoto.frame.origin = CGPoint(x: self.viewOfPhoto.frame.origin.x + 800, y: self.viewOfPhoto.frame.origin.y + 100)
        }, completion: {_ in
            MichTransport.getrandompost(token: (UIApplication.shared.delegate as! AppDelegate).token!, successCallbackGetRandomPost: self.onSuccessGetRandomPost, errorCallbackGetRandomPost: self.onerror)
            self.viewOfPhoto.frame.origin = CGPoint(x: self.viewOfPhoto.frame.origin.x - 800, y: self.viewOfPhoto.frame.origin.y - 100)
        })
    }
    
    @IBAction func UnlikePhoto(_ sender: Any) {
        UIView.animate(withDuration: 0.6, animations: {
            self.viewOfPhoto.frame.origin = CGPoint(x: self.viewOfPhoto.frame.origin.x - 800, y: self.viewOfPhoto.frame.origin.y + 100)
        }, completion: {_ in
            MichTransport.getrandompost(token: (UIApplication.shared.delegate as! AppDelegate).token!, successCallbackGetRandomPost: self.onSuccessGetRandomPost, errorCallbackGetRandomPost: self.onerror)
            self.viewOfPhoto.frame.origin = CGPoint(x: self.viewOfPhoto.frame.origin.x + 800, y: self.viewOfPhoto.frame.origin.y - 100)
        
        })
    }
    
    
    // MARK: navigaiton
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "showpost" {
            (segue.destination as! PostViewController).postId = (sender as! MichSwipePhotosViewController).postRandom.id
        }
    }

    // MARK: callbacks
    func onSuccessGetRandomPost(post: PostClass) {
        postRandom = post
        Nuke.loadImage(with: Foundation.URL(string: post.image!)!, into: self.randomImage)
        username.text = post.userName!
        tittle.text = post.title!
        
    }

    func onSuccessForLike() {
        print("post liked")
    }
    
    func onerror(error: DefaultError){
        let alert = UIAlertController(title: "Alert", message: error.errorString, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
