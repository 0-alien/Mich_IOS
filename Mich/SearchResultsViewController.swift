//
//  SearchResultsViewController.swift
//  Mich
//
//  Created by Gigi Pataraia on 2/17/17.
//  Copyright © 2017 Gigi. All rights reserved.
//

import UIKit
import Nuke

class SearchResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    var data: [User] = []
    var destinationUser: User!
    var userChoosenDelegate: UserListener?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultsTableViewCell", for: indexPath) as! SearchResultsTableViewCell
        cell.userName.text = data[indexPath.row].name
        Nuke.loadImage(with: Foundation.URL(string: data[indexPath.row].avatar!)!, into: cell.userImage)
        cell.userImage.image = cell.userImage.image?.circle
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userId: Int = data[indexPath.row].id!
        userChoosenDelegate?.gotoUserPage(id: userId)
    }
    
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
        data = users
        tableView.reloadData()
    }
    func onerror(error: DefaultError){
        let alert = UIAlertController(title: "Alert", message: error.errorString, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

protocol UserListener {
    func gotoUserPage(id: Int)
}


