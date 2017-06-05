//
//  CommentsViewController.swift
//  Mich
//
//  Created by Gigi Pataraia on 3/7/17.
//  Copyright © 2017 Gigi. All rights reserved.
//

import UIKit
import Nuke

class CommentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CommentDelegate {
    
    
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var addComments: UITextField!
    @IBOutlet weak var tableView: UITableView!
   
    var postId: Int!
    var needsToShowComment: Bool! = false
    var destinationCommentId: Int! = nil //comment added/liked notificatioin
    
    var comments: [Comment] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        MichTransport.getpostcomments(token: (UIApplication.shared.delegate as! AppDelegate).token!, id: postId, successCallbackForgetuserposts: onGetCommentsSuccess, errorCallbackForgetuserposts: onError)
        
        addComments.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        self.tableView.estimatedRowHeight = 40
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
        Nuke.loadImage(with: Foundation.URL(string: comments[indexPath.row].avatar!)!, into: cell.userImage)
        cell.userImage = cell.userImage.circle
        cell.data.text = self.comments[indexPath.row].data
        cell.commentIndex = indexPath.row
        cell.delegate = self
        cell.liked = (comments[indexPath.row].myLike == 1)
        cell.setLikeCount(count: comments[indexPath.row].nLikes!)
        
        
        cell.editCommentButton.isHidden = false
/*
        if (comments[indexPath.row].userId == (UIApplication.shared.delegate as! AppDelegate).user?.id) {
            cell.editCommentButton.isHidden = false

        }
        else {
            cell.editCommentButton.isHidden = true
        }
 */
 
        return cell
        
    }

 
///////////////// scrolling
    
    
    @IBAction func postButton(_ sender: Any) {
   
        let comment = addComments.text!
        
        MichTransport.addcomment(token: (UIApplication.shared.delegate as! AppDelegate).token!, postID: postId, comment: comment, successCallbackForAddComment: onAddCommentSuccess, errorCallbackForAddComment: onError)
        
    }
    

    func textFieldDidChange(_ textField: UITextField) {
        if(addComments.text!  == ""){
            postButton.isEnabled = false;
        }else{
            postButton.isEnabled = true;
        }
    }

    func onAddCommentSuccess(comment: Comment) {
        comments.append(comment)
        tableView.reloadData()
        tableViewScrollToBottom(animated: true)
        
        addComments.text! = ""
        
    }
    
    
    
    func keyboardNotification(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                self.bottomConstraint.constant = 0.0
            } else {
                self.bottomConstraint.constant = (endFrame?.size.height ?? 0.0)
            }
            if (comments.count > 0) {
                UIView.animate(withDuration: duration, delay: TimeInterval(0), options: animationCurve, animations: {self.view.layoutIfNeeded()
                    self.tableView.scrollToRow(at: IndexPath(row: self.comments.count - 1, section: 0), at: .bottom, animated: false)}, completion: nil)
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        addComments.resignFirstResponder()
        postButton(self)

        
        return true
    }
    
    
    func hideKeyboard() {
        addComments.resignFirstResponder()
    }
    
    func tableViewScrollToBottom(animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            let numberOfSections = self.tableView.numberOfSections
            let numberOfRows = self.tableView.numberOfRows(inSection: numberOfSections - 1)
            if numberOfRows > 0 {
                let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections - 1))
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
            }
        }
    }

    

    
    // MARK: callbacks
    func onGetCommentsSuccess(resp: [Comment]) {
        self.comments.removeAll()
        self.comments.append(contentsOf: resp)
        self.tableView.reloadData()
        
        if needsToShowComment {
            needsToShowComment = false
            for i in 0 ..< comments.count {
                if comments[i].id == destinationCommentId {
                    tableView.scrollToRow(at: IndexPath(row: i, section: 0), at: .top, animated: true)
                    let cell: CommentCell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as! CommentCell
                    cell.backgroundColor = UIColor.orange
                    UIView.animate(withDuration: 1.5, animations: {cell.backgroundColor = UIColor.white})
                    break
                }
            }
        }
    }
    
    
    func onError(error: DefaultError){
        let alert = UIAlertController(title: "Alert", message: error.errorString, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func onLikeCommentSuccess(commentId: Int) {
        for com in self.comments {
            if com.id == commentId {
                com.nLikes = com.nLikes! + 1
                com.myLike = 1
                break
            }
        }
        self.tableView.reloadData()
    }
    func onUnlikeCommentSuccess(commentId: Int) {
        for com in self.comments {
            if com.id == commentId {
                com.nLikes = com.nLikes! - 1
                com.myLike = 0
                break
            }
        }
        self.tableView.reloadData()
    }
    
    // MARK: commentDelegate
    func onCommentLike(commentIndex: Int) {
        let com = comments[commentIndex]
        MichTransport.likecomment(token: (UIApplication.shared.delegate as! AppDelegate).token!, commentID: com.id!, successCallbackForLikeComment: onLikeCommentSuccess, errorCallbackForLikeComment: onError)
        
    }
    func onCommentUnlike(commentIndex: Int) {
        let com = comments[commentIndex]
        MichTransport.unlikecomment(token: (UIApplication.shared.delegate as! AppDelegate).token!, commentID: com.id!, successCallbackForUnLikeComment: onUnlikeCommentSuccess, errorCallbackForUnLikeComment: onError)
    }
    
    func onEditComment(commentIndex: Int) {
        let com = comments[commentIndex]
//        print(com.data)
        
        let alert = UIAlertController()
        
        if (com.userId == (UIApplication.shared.delegate as! AppDelegate).user?.id){
        
            let deleteComment = UIAlertAction(title: "Delete", style: .destructive, handler: { ACTION in
                MichTransport.deletecomment(token: (UIApplication.shared.delegate as! AppDelegate).token!, commentID: com.id!, successCallbackForDeleteComment: self.onDeleteComment, errorCallbackForDeleteComment: self.onError)
            
            })
            alert.addAction(deleteComment)
        }else{
            let reportComment = UIAlertAction(title: "Report", style: .destructive, handler: { ACTION in
               
                MichTransport.reportcomment(token: (UIApplication.shared.delegate as! AppDelegate).token!, commentID: com.id!, successCallbackForReportComment: self.onReportComment, errorCallbackForReportComment: self.onError)
            })
            alert.addAction(reportComment)
        }
        
        
        

        
        let copyComment = UIAlertAction(title: "Copy", style: .default, handler: { ACTION in
            
            UIPasteboard.general.string = com.data
        })
        alert.addAction(copyComment)
        
        
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel,handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
   
    func onReportComment(commentId: Int) {
        let alert = UIAlertController(title: "Alert", message: "Comment Reported", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func onDeleteComment(commentId: Int) {
        var index = 0
        
        for com in self.comments {
            if com.id == commentId {
                comments.remove(at: index)
                break
            }
            index = index+1
        }
        self.tableView.reloadData()
    
    }
    
    
}
