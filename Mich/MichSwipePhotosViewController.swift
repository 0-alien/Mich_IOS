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
    
    var nextImage: UIImage! = nil
    var nextPost: PostClass! = nil
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
            if self.nextPost == nil {
                MichTransport.getrandompost(token: (UIApplication.shared.delegate as! AppDelegate).token!, successCallbackGetRandomPost: self.onSuccessGetRandomPost, errorCallbackGetRandomPost: self.onerror)
            } else {
                self.postRandom = self.nextPost
                self.username.text = self.nextPost.userName!
                self.tittle.text = self.nextPost.title!
                self.randomImage.image = self.nextImage
                MichTransport.getrandompost(token: (UIApplication.shared.delegate as! AppDelegate).token!, successCallbackGetRandomPost: self.prefetchSuccess,
                                            errorCallbackGetRandomPost: self.onerror)
            }
            self.viewOfPhoto.frame.origin = CGPoint(x: self.viewOfPhoto.frame.origin.x - 800, y: self.viewOfPhoto.frame.origin.y - 100)
        })
    }
    
    @IBAction func UnlikePhoto(_ sender: Any) {
        UIView.animate(withDuration: 0.6, animations: {
            self.viewOfPhoto.frame.origin = CGPoint(x: self.viewOfPhoto.frame.origin.x - 800, y: self.viewOfPhoto.frame.origin.y + 100)
        }, completion: {_ in
            if self.nextPost == nil {
                MichTransport.getrandompost(token: (UIApplication.shared.delegate as! AppDelegate).token!, successCallbackGetRandomPost: self.onSuccessGetRandomPost, errorCallbackGetRandomPost: self.onerror)
            } else {
                self.postRandom = self.nextPost
                self.username.text = self.nextPost.userName!
                self.tittle.text = self.nextPost.title!
                self.randomImage.image = self.nextImage
                MichTransport.getrandompost(token: (UIApplication.shared.delegate as! AppDelegate).token!, successCallbackGetRandomPost: self.prefetchSuccess,
                                            errorCallbackGetRandomPost: self.onerror)
            }
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
        username.text = post.userName!
        tittle.text = post.title!
        Nuke.loadImage(with: Foundation.URL(string: post.image!)!, into: self.randomImage)
        MichTransport.getrandompost(token: (UIApplication.shared.delegate as! AppDelegate).token!, successCallbackGetRandomPost: self.prefetchSuccess,
                                    errorCallbackGetRandomPost: self.onerror)
    }
    
    func prefetchSuccess(post: PostClass) {
        self.nextPost = post
        let url = URL(string: post.image!)
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            DispatchQueue.main.async {
                self.nextImage = UIImage(data: data!)
            }
        }
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
