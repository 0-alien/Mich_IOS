//
//  TagImageViewController.swift
//  Mich
//
//  Created by Gigi Pataraia on 7/26/17.
//  Copyright © 2017 Lemon. All rights reserved.
//

import UIKit
import Nuke

class TagImageViewController: UIViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var photo: UIImageView!
    var image: UIImage!
    @IBOutlet weak var writeACaptionTextView: UITextView!
    var placeholderLabel : UILabel!
    var queryIndex: Int?
    var queryString: String?
    @IBOutlet weak var tableView: UITableView!
    var users: [User] = []
    @IBOutlet weak var doneBTN: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        writeACaptionTextView.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "Write A Caption.."
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: (writeACaptionTextView.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        writeACaptionTextView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (writeACaptionTextView.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !writeACaptionTextView.text.isEmpty
        photo.image = image
    }

    
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        if (textView.text.isEmpty) {
            self.users.removeAll()
            self.tableView.reloadData()
            self.tableView.isHidden = true
            return
        }
        let data: String = textView.text
        for i in 2 ..< data.characters.count + 1 {
            let tmp = data.index(data.endIndex, offsetBy: -i)
            if (data[tmp] == " ") {
                self.tableView.isHidden = true
                self.users.removeAll()
                self.tableView.reloadData()
                break
            }
            if (data[tmp] == "@") {
                if (i == data.characters.count || (i < data.characters.count && data[data.index(data.endIndex, offsetBy: -i - 1)] == " ")) {
                    let range = data.index(data.endIndex, offsetBy: -i + 1)..<data.endIndex
                    self.queryString = data[range]
                    self.updateTagTableView(data: self.queryString!)
                    self.queryIndex = -i
                    break
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        writeACaptionTextView.becomeFirstResponder()
        self.tableView.isHidden = true
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: actions
    @IBAction func post(_ sender: Any) {
        doneBTN.isEnabled = false;
        var title = writeACaptionTextView.text
        if title == nil {
            title = " ";
        }
        MichTransport.createpost(token: (UIApplication.shared.delegate as! AppDelegate).token!, title: title!, image: self.image, successCallbackForCreatePost: onSuccess, errorCallbackForCreatePost: onError)
    }
    
    // MARK: callbacks
    func onSuccess() {
        self.tabBarController?.selectedIndex = 0
        if ((self.tabBarController?.viewControllers?[0] as! UINavigationController).viewControllers[0] as! PostsViewController).posts.count > 0 {
            ((self.tabBarController?.viewControllers?[0] as! UINavigationController).viewControllers[0] as! PostsViewController).tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
        _ = self.navigationController?.popToRootViewController(animated: false)
    }
    
    func onError(error: DefaultError) {
        let alert = UIAlertController(title: "Alert", message: error.errorString, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    private func onSearchUsersSuccess(users: [User]) {
        self.users = users
        self.tableView.reloadData()
    }
    // MARK: tableview delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.writeACaptionTextView.text = self.writeACaptionTextView.text[Range(self.writeACaptionTextView.text.startIndex ..<
            //self.writeACaptionTextView.text.index(self.writeACaptionTextView.text.endIndex, offsetBy: queryIndex!))] + "@" +
            //self.users[indexPath.row].username! + " "
        self.writeACaptionTextView.text = self.writeACaptionTextView.text.prefix(self.writeACaptionTextView.text.count + queryIndex!) + "@" +
            self.users[indexPath.row].username! + " "
        self.tableView.isHidden = true
        self.users.removeAll()
        self.tableView.reloadData()
    }
    // MARK: tableview datasource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TagTableViewCell", for: indexPath) as! TagTableViewCell
        cell.userName.text = self.users[indexPath.row].username
        Nuke.loadImage(with: Foundation.URL(string: users[indexPath.row].avatar!)!, into: cell.userImage)
        cell.userImage = cell.userImage.circle
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    // MARK: class methods
    private func updateTagTableView(data: String) {
        self.tableView.isHidden = false
        MichTransport.searchusers(token: (UIApplication.shared.delegate as! AppDelegate).token!, term: data,
                                  successCallbackForsearchusers: self.onSearchUsersSuccess,
                                  errorCallbackForsearchusers: {_ in self.users.removeAll(); self.tableView.reloadData()})
    }
    
    
    
}
