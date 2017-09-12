//
//  MichHomeViewController.swift
//  Mich
//
//  Created by Gigi Pataraia on 8/10/17.
//  Copyright © 2017 Lemon. All rights reserved.
//

import UIKit

class MichHomeViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UserListener {
    
    var viewControllerList: [UIViewController] = [UIViewController]()
    var searchController: UISearchController!
    var resultsShower: SearchResultsViewController!
    var currentViewController: UIViewController! = nil
    var destinationUserId: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        self.viewControllerList.append(UIStoryboard(name: "Mich", bundle: nil).instantiateViewController(withIdentifier: "Search"))
        self.viewControllerList.append(UIStoryboard(name: "Mich", bundle: nil).instantiateViewController(withIdentifier: "Tinder"))
        
        resultsShower = UIStoryboard(name: "Mich", bundle: nil).instantiateViewController(withIdentifier: "SearchResultsViewController") as! SearchResultsViewController
        resultsShower.userChoosenDelegate = self
        searchController = UISearchController(searchResultsController: resultsShower)
        searchController.searchResultsUpdater = resultsShower
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Search Mich"
        searchController.searchBar.sizeToFit()
        searchController.definesPresentationContext = false
        searchController.hidesNavigationBarDuringPresentation = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationItem.titleView = searchController.searchBar
        if currentViewController == nil {
            currentViewController = self.viewControllerList.first
            setViewControllers([currentViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: Datasource
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = viewControllerList.index(of: viewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
            return nil
        }
        guard viewControllerList.count > previousIndex else {
            return nil
        }
        return viewControllerList[previousIndex]
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = viewControllerList.index(of: viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = viewControllerList.count
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        return viewControllerList[nextIndex]
    }
    
    // MARK: delegate
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            var index = viewControllerList.index(of: previousViewControllers.first!)
            if index == 0 {
                searchController.searchBar.isHidden = true
                currentViewController = self.viewControllerList[1]
            } else {
                searchController.searchBar.isHidden = false
                currentViewController = self.viewControllerList[0]
            }
        }
    }
    //MARK: Userlistener
    func gotoUserPage(id: Int) {
        self.destinationUserId = id
        performSegue(withIdentifier: "gotoprofilepage", sender: self)
        searchController.dismiss(animated: false, completion: {})
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "gotoprofilepage" {
            (segue.destination as! UserPicturesCollectionViewController).userId = self.destinationUserId
        }
    }
 

}
