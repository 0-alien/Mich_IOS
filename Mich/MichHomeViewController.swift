//
//  MichHomeViewController.swift
//  Mich
//
//  Created by Gigi Pataraia on 8/10/17.
//  Copyright © 2017 Lemon. All rights reserved.
//

import UIKit

class MichHomeViewController: SlidingMenuPresentingViewController, UserListener {
    
    var viewControllerList: [UIViewController] = [UIViewController]()
    var searchController: UISearchController!
    var resultsShower: SearchResultsViewController!
    var currentViewController: UIViewController! = nil
    var destinationUserId: Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.currentIndex = 3
        
        self.viewControllerList.append(UIStoryboard(name: "Mich", bundle: nil).instantiateViewController(withIdentifier: "Tinder"))
        //self.viewControllerList.append(UIStoryboard(name: "Mich", bundle: nil).instantiateViewController(withIdentifier: "Search"))
        resultsShower = UIStoryboard(name: "Mich", bundle: nil).instantiateViewController(withIdentifier: "SearchResultsViewController") as! SearchResultsViewController
        resultsShower.userChoosenDelegate = self
        searchController = UISearchController(searchResultsController: resultsShower)
        searchController.searchResultsUpdater = resultsShower
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Search Mich"
        searchController.definesPresentationContext = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.isHidden = false
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.topItem?.titleView = searchController.searchBar
        } else {
            self.navigationItem.titleView = searchController.searchBar
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Userlistener
    func gotoUserPage(id: Int) {
        self.destinationUserId = id
        performSegue(withIdentifier: "gotoprofilepage", sender: self)
        searchController.dismiss(animated: false, completion: {})
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "gotoprofilepage" {
            (segue.destination as! UserPicturesCollectionViewController).userId = self.destinationUserId
        }
    }
   

}
