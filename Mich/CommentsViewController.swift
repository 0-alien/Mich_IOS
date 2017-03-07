//
//  CommentsViewController.swift
//  Mich
//
//  Created by Gigi Pataraia on 3/7/17.
//  Copyright © 2017 Gigi. All rights reserved.
//

import UIKit

class CommentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var postId: Int!
    var comments: [Comment] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        MichTransport.getpostcomments(token: (UIApplication.shared.delegate as! AppDelegate).token!, id: postId, successCallbackForgetuserposts: onGetCommentsSuccess, errorCallbackForgetuserposts: onError)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.comments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
        cell.userPicture.image = cell.userPicture.image?.circle
        cell.userName.text = comments[indexPath.row].userName
        cell.data.text = self.comments[indexPath.row].data
        cell.answersButton.tag = indexPath.row
        cell.setRating(indexPath.row % 5 + 1)
        return cell
        
    }


    // MARK: callbacks
    func onGetCommentsSuccess(resp: [Comment]) {
        self.comments.removeAll()
        self.comments.append(contentsOf: resp)
        self.tableView.reloadData()
        print(self.comments.count)
    }
    func onError(error: DefaultError){
        let alert = UIAlertController(title: "Alert", message: error.errorString, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
