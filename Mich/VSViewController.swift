//
//  VSViewController.swift
//  Mich
//
//  Created by Gigi Pataraia on 12/29/16.
//  Copyright © 2016 Gigi. All rights reserved.
//

import UIKit

class VSViewController: SlidingMenuPresentingViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    var searchController: UISearchController!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.sectionHeaderHeight = 30
        currentIndex = 1
        self.tableView.rowHeight = 80
        //self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "pixel"), for: .default)
        self.navigationController?.navigationBar.isHidden = true
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Search Battles"
        //searchController.delegate = self
        searchController.searchBar.sizeToFit()
        //definesPresentationContext = true
        searchController.hidesNavigationBarDuringPresentation = false
        self.tableView.tableHeaderView = searchController.searchBar
        // Do any additional setup after loading the view.
    }
    public func updateSearchResults(for searchController: UISearchController) {
        let pat: String? = searchController.searchBar.text
        print(pat!)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let frame = CGRect(x: 0, y: 0, width: self.tableView!.frame.size.width, height: 15);
        if (section == 0) {
            return VSTableViewSectionHeader(frame: frame, labelName: " Active Now", seeMoreCount: 11, listener: self, selector: #selector(VSViewController.activeSeeMore(_:)))
        }
        else {
            return VSTableViewSectionHeader(frame: frame, labelName: " More Conversations", seeMoreCount: 3, listener: self, selector: #selector(VSViewController.moreSeeMore(_:)))
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VSTableViewCell", for: indexPath) as! VSTableViewCell
        return cell
    }

    func activeSeeMore(_ button: UIButton) {
        performSegue(withIdentifier: "vsseague", sender: self)
    }
    
    func moreSeeMore(_ button: UIButton) {
        print("more")
    }
    
}
