//
//  MichSearchViewController.swift
//  Mich
//
//  Created by Gigi Pataraia on 10/18/16.
//  Copyright © 2016 Gigi. All rights reserved.
//

import UIKit

class MichSearchViewController: SlidingMenuPresentingViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private let reuseIdentifier = "UserPicturesCollectionViewCell"
    let spaceing : CGFloat = 1.0
    let itemsPerRow : CGFloat = 3.0
    var imageSideLength : CGFloat = 0.0
    var searchController: UISearchController!
    var resultsShower: SearchResultsTableViewController!
    
    @IBOutlet weak var imageCollection: UICollectionView!
    var data = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentIndex = 3
        //configureSearchController()
        definesPresentationContext = true
        imageSideLength = (self.view.frame.size.width - (itemsPerRow - 1) * spaceing)  / itemsPerRow
        
        for _ in 0 ..< 3 {
            for _ in 0 ..< 30 {
                data.append("login_background")
            }
        }
        resultsShower = UIStoryboard(name: "Mich", bundle: nil).instantiateViewController(withIdentifier: SearchResultsTableViewController.storyboardID) as! SearchResultsTableViewController
        searchController = UISearchController(searchResultsController: resultsShower)
        searchController.searchResultsUpdater = resultsShower
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Search Mich"
        //searchController.delegate = self
        searchController.searchBar.sizeToFit()
        searchController.definesPresentationContext = true
        searchController.hidesNavigationBarDuringPresentation = false
        self.navigationItem.titleView = searchController.searchBar
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! UserPicturesCollectionViewCell
        let imageName = data[indexPath.item]
        cell.photo.image = UIImage(named: imageName)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: imageSideLength, height: imageSideLength)
    }
    
}
