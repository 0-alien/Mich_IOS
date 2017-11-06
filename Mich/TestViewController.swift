//
//  ContainerViewController.swift
//  Test
//
//  Created by Gigi Pataraia on 10/31/17.
//  Copyright © 2017 Gigi. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class TestViewController: ButtonBarPagerTabStripViewController, UserListener {
    
    var searchController: UISearchController!
    var resultsShower: SearchResultsViewController!
    var destinationUserId: Int!
    
    override func viewDidLoad() {
        
        settings.style.buttonBarBackgroundColor = UIColor.white
        settings.style.buttonBarItemBackgroundColor = UIColor.white
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarItemTitleColor = UIColor.red
        settings.style.buttonBarMinimumInteritemSpacing = 0
        settings.style.selectedBarHeight = 1
        settings.style.selectedBarBackgroundColor = UIColor.red
        super.viewDidLoad()
        
        resultsShower = UIStoryboard(name: "Mich", bundle: nil).instantiateViewController(withIdentifier: "SearchResultsViewController") as! SearchResultsViewController
        resultsShower.userChoosenDelegate = self
        
        searchController = UISearchController(searchResultsController: resultsShower)
        searchController.searchResultsUpdater = resultsShower
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Search Mich"
        searchController.definesPresentationContext = false
        searchController.hidesNavigationBarDuringPresentation = false
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
    
    override public func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let vc1: MichSwipePhotosViewController = UIStoryboard(name: "Mich", bundle: nil).instantiateViewController(withIdentifier: "Tinder") as! MichSwipePhotosViewController
        let vc2: MichSearchViewController = UIStoryboard(name: "Mich", bundle: nil).instantiateViewController(withIdentifier: "Search") as! MichSearchViewController
        vc1.searchController = self.searchController
        vc2.searchController = self.searchController
        return [vc1, vc2]
    }
    
    //MARK: Userlistener
    func gotoUserPage(id: Int) {
        self.destinationUserId = id
        performSegue(withIdentifier: "gotoprofilepage", sender: self)
        searchController.dismiss(animated: false, completion: {})
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "gotoprofilepage" {
            (segue.destination as! UserPicturesCollectionViewController).userId = self.destinationUserId
        }
    }
}

