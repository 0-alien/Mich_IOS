//
//  CommentsTableViewController.swift
//  Mich
//
//  Created by Gigi Pataraia on 9/28/16.
//  Copyright © 2016 Gigi. All rights reserved.
//

import UIKit

class CommentsTableViewController: UITableViewController {
    var postId: Int!
    var types = [Int]()
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
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.comments.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
        cell.userPicture.image = cell.userPicture.image?.circle
        cell.userName.text = comments[indexPath.row].userName
        cell.data.text = self.comments[indexPath.row].data
        cell.answersButton.tag = indexPath.row
        cell.setRating(indexPath.row % 5 + 1)
        return cell
        
    }
    

    //MARK: - Actions
    @IBAction func showAnswers(_ sender: Any) {
        let tag = (sender as! UIButton).tag
        if (tag < types.count - 1 && types[tag + 1] == 1) {
            return;
        }
        for i in 1 ..< 3 {
            types.insert(1, at: i + tag)
        }
        self.tableView.reloadData()
        let indexPath = IndexPath(row: tag + 2, section: 0)
        tableView.scrollToRow(at: indexPath, at: .none, animated: true)
    }
    
    // MARK: callbacks
    func onGetCommentsSuccess(resp: [Comment]) {
        self.comments.removeAll()
        self.comments.append(contentsOf: resp)
        self.tableView.reloadData()
    }
    func onError(error: DefaultError){
        let alert = UIAlertController(title: "Alert", message: error.errorString, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
