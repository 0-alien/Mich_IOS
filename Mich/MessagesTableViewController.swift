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
    var filtered: [User] = []
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
        cell.userName.text = filtered[indexPath.row].username
        cell.profilePicture = cell.profilePicture.circle
        Nuke.loadImage(with: Foundation.URL(string: (filtered[indexPath.row].avatar)!)!, into: cell.profilePicture)
        return cell
    }
    
    // MARK: navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "showchat" {
            let indexPath = self.tableView.indexPath(for: sender as! MessagesTableViewCell)
            (segue.destination as! ChatViewController).userId = self.filtered[(indexPath?.row)!].id
            (segue.destination as! ChatViewController).senderId = String(((UIApplication.shared.delegate as! AppDelegate).user?.id)! + 0)
            (segue.destination as! ChatViewController).senderDisplayName = (UIApplication.shared.delegate as! AppDelegate).user?.username
        }
    }
    // MARK: callbacks
    func onGetMessagesSuccess(resp: [Chat]) {
        self.data = resp
        self.filterData(query: self.searchController.searchBar.text!)
        self.tableView.reloadData()
    }
    func onSearchUsersSuccess(users: [User]) {
        filtered.removeAll()
        filtered.append(contentsOf: users)
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
        if query == "" {
            self.filtered.removeAll()
            for chat in self.data {
                filtered.append(chat.user!)
            }
            return
        }
        MichTransport.searchusers(token: (UIApplication.shared.delegate as! AppDelegate).token!, term: query, successCallbackForsearchusers: onSearchUsersSuccess, errorCallbackForsearchusers: onError)
    }
}
