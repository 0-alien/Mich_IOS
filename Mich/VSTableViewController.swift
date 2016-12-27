//
//  VSTableViewController.swift
//  Mich
//
//  Created by Gigi Pataraia on 10/10/16.
//  Copyright © 2016 Gigi. All rights reserved.
//

import UIKit

class VSTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.sectionHeaderHeight = 30
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "pixel"), for: .default)
        self.navigationController?.navigationBar.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(PostsTableViewController.showNotifications), name: NSNotification.Name(rawValue: "showNotifications"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PostsTableViewController.showMessages), name: NSNotification.Name(rawValue: "showMessages"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PostsTableViewController.showSettings), name: NSNotification.Name(rawValue: "showSettings"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PostsTableViewController.showHelp), name: NSNotification.Name(rawValue: "showHelp"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let frame = CGRect(x: 0, y: 0, width: self.tableView!.frame.size.width, height: 15);
        if (section == 0) {
            return VSTableViewSectionHeader(frame: frame, labelName: " Active Now", seeMoreCount: 11, listener: self, selector: #selector(VSTableViewController.activeSeeMore(_:)))
        }
        else {
            return VSTableViewSectionHeader(frame: frame, labelName: " More Conversations", seeMoreCount: 3, listener: self, selector: #selector(VSTableViewController.moreSeeMore(_:)))
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 7
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VSTableViewCell", for: indexPath) as! VSTableViewCell
        return cell
    }
    
    //Mark: - Actions
    
    func activeSeeMore(_ button: UIButton) {
        print("active")
    }
    
    func moreSeeMore(_ button: UIButton) {
        print("more")
    }

}
extension VSTableViewController {
    func showNotifications() {
        if (tabBarController?.selectedIndex == 1) {
            performSegue(withIdentifier: "notifications", sender: nil)
        }
    }
    func showMessages() {
        if (tabBarController?.selectedIndex == 1) {
            performSegue(withIdentifier: "messages", sender: nil)
        }
    }
    func showSettings() {
        if (tabBarController?.selectedIndex == 1) {
            performSegue(withIdentifier: "settings", sender: nil)
        }
    }
    func showHelp() {
        if (tabBarController?.selectedIndex == 1) {
            performSegue(withIdentifier: "help", sender: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "disableScrolling"), object: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "enableScrolling"), object: nil)
    }
    
}
