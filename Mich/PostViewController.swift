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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userImage.image = userImage.image?.circle
        postTitle.text = post.title
        postDate.text = post.created_at
        
        Nuke.loadImage(with: Foundation.URL(string: post.image!)!, into: postImage)
        
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
    
}
