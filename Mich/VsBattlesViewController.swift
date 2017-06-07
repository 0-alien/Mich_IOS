//
//  VsBattlesViewController.swift
//  Mich
//
//  Created by Gigi Pataraia on 1/17/17.
//  Copyright © 2017 Gigi. All rights reserved.
//

import UIKit

class VsBattlesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var searchController: UISearchController!
    @IBOutlet weak var navBarReplacement: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80
    
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Search Battles"
        //searchController.delegate = self
        searchController.searchBar.sizeToFit()
        //definesPresentationContext = true
        self.navigationItem.titleView = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = false
    }
    public func updateSearchResults(for searchController: UISearchController) {
        let pat: String? = searchController.searchBar.text
        print(pat!)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10;
    }
    
    

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VSTableViewCell", for: indexPath) as! VSTableViewCell
        return cell
    }


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "JSQ" {
            (segue.destination as! VSJSQViewController).senderId = "Gigi"
            (segue.destination as! VSJSQViewController).senderDisplayName = "Gigi"
        }
    }
    

}
