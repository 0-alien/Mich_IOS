//
//  CommentsTableViewController.swift
//  Mich
//
//  Created by Gigi Pataraia on 9/28/16.
//  Copyright © 2016 Gigi. All rights reserved.
//

import UIKit

class CommentsTableViewController: UITableViewController {
    
    var types = [Int]()
    override func viewDidLoad() {
        super.viewDidLoad()
        for _ in 1 ..< 20 {
            types.append(0)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return types.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (types[indexPath.row] == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
            cell.userName.text = String(indexPath.row)
            cell.answersButton.tag = indexPath.row
            cell.setRating(indexPath.row % 5 + 1)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReplyCell", for: indexPath) as! ReplyCell
            cell.userName.text = String(indexPath.row)
            cell.userName.textColor = UIColor.blue
            return cell
        }
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

}
