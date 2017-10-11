//
//  MessagesTableViewController.swift
//  Mich
//
//  Created by Gigi Pataraia on 10/9/17.
//  Copyright © 2017 Lemon. All rights reserved.
//

import UIKit
import Nuke

class MessagesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    var data: [Chat] = []
    var filtered: [Chat] = []
    @IBOutlet weak var tableView: UITableView!
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Messages"
        searchController.definesPresentationContext = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.autocapitalizationType = .none
        
        self.tableView.tableHeaderView = searchController.searchBar
        
        MichMessagesTransport.getMessages(token: (UIApplication.shared.delegate as! AppDelegate).token!, successCallbackGetMessages: onGetMessagesSuccess, errorCallbackForGetMessages: onError)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: tableview datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtered.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessagesTableViewCell", for: indexPath) as! MessagesTableViewCell
        cell.userName.text = filtered[indexPath.row].user?.username
        Nuke.loadImage(with: Foundation.URL(string: (data[indexPath.row].user?.avatar)!)!, into: cell.profilePicture)
        return cell
    }
    // MARK: callbacks
    func onGetMessagesSuccess(resp: [Chat]) {
        self.data = resp
        self.filterData(query: self.searchController.searchBar.text!)
        self.tableView.reloadData()
    }
    func onError(error: DefaultError){
        let alert = UIAlertController(title: "Alert", message: error.errorString, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    // MARK: searchController
    func updateSearchResults(for searchController: UISearchController) {
        self.filterData(query: searchController.searchBar.text!)
        self.tableView.reloadData()
    }
    
    // MARK: class methods
    func filterData(query: String) {
        self.filtered.removeAll()
        if query == "" {
            filtered.append(contentsOf: data)
            return
        }
        for chat in data {
            if chat.user?.username?.lowercased().range(of: query.lowercased()) != nil {
                self.filtered.append(chat)
            }
        }
    }
    
}
