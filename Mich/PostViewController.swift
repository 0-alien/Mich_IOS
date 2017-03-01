//
//  PostViewController.swift
//  Mich
//
//  Created by Gigi Pataraia on 2/28/17.
//  Copyright © 2017 Gigi. All rights reserved.
//

import UIKit
import Nuke

class PostViewController: UIViewController {

    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postDate: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var postImage: UIImageView!
    var post: PostClass!
    var postId: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MichTransport.getpost(token: (UIApplication.shared.delegate as! AppDelegate).token!, id: postId,
                            successCallbackForgetpost: onGetPostSuccess, errorCallbackForgetpost: onGetPostError)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "showcomments" {
            (segue.destination as! CommentsTableViewController).postId = post.id
        }
    }
    
    func loadPost() {
        self.postTitle.text = self.post.title
        self.postDate.text = self.post.created_at
        self.userName.text = self.post.userName
        Nuke.loadImage(with: Foundation.URL(string: self.post.image!)!, into: self.postImage)
        Nuke.loadImage(with: Foundation.URL(string: self.post.avatar!)!, into: self.userImage)
        
    }
    
    // MARK: callbacks
    func onGetPostSuccess(resp: PostClass) {
        self.post = resp
        self.loadPost()
    }
    
    func onGetPostError(error: DefaultError){
        let alert = UIAlertController(title: "Alert", message: error.errorString, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
