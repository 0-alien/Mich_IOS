//
//  TagTableViewController.swift
//  Mich
//
//  Created by Gigi Pataraia on 9/1/17.
//  Copyright © 2017 Lemon. All rights reserved.
//

import UIKit
import AlamofireImage
import Nuke

class TagTableViewController: UIViewController, UISearchResultsUpdating, UITableViewDelegate, UITableViewDataSource {
    var searchController: UISearchController!
    var users: [User] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Mich"
        searchController.searchBar.sizeToFit()
        searchController.definesPresentationContext = false
        searchController.hidesNavigationBarDuringPresentation = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.titleView = searchController.searchBar
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: tableview datasource 
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TagTableViewCell", for: indexPath) as! TagTableViewCell
        //cell.userName.text = users[indexPath.row].username
        Nuke.loadImage(with: Foundation.URL(string: users[indexPath.row].avatar!)!, into: cell.userImage)
        return cell
    }
    
    // MARK: searchresults updateing
    public func updateSearchResults(for searchController: UISearchController) {
        var txt: String = ""
        if (searchController.searchBar.text != nil) {
            txt = searchController.searchBar.text!
        }
        if (txt == "") {
            return
        }
        MichTransport.searchusers(token: (UIApplication.shared.delegate as! AppDelegate).token!, term: txt,
                                  successCallbackForsearchusers: onsuccess, errorCallbackForsearchusers: onerror)
    }
    
    // MARK: callbacks
    func onsuccess(users: [User]) {
        self.users = users
        tableView.reloadData()
    }
    func onerror(error: DefaultError){
        let alert = UIAlertController(title: "Alert", message: error.errorString, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
