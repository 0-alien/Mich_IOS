//
//  MichSearchViewController.swift
//  Mich
//
//  Created by Gigi Pataraia on 10/18/16.
//  Copyright © 2016 Gigi. All rights reserved.
//

import UIKit
import Nuke

class MichSearchViewController: SlidingMenuPresentingViewController, UICollectionViewDataSource, UserListener {
    
    private let reuseIdentifier = "UserPicturesCollectionViewCell"
    let spaceing : CGFloat = 1.0
    let itemsPerRow : CGFloat = 3.0
    var imageSideLength : CGFloat = 0.0
    var searchController: UISearchController!
    var resultsShower: SearchResultsViewController!
    var destinationUserId: Int?
    var destinationPostId: Int?
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(MichSearchViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        return refreshControl
    }()
    
    
    @IBOutlet weak var imageCollection: UICollectionView!
    var data: [PostClass] = [PostClass]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.definesPresentationContext = true
        self.automaticallyAdjustsScrollViewInsets = false
        imageSideLength = (self.view.frame.size.width - (itemsPerRow - 1) * spaceing)  / itemsPerRow
        if #available(iOS 10.0, *) {
            self.imageCollection.refreshControl = refreshControl
        } else {
            self.imageCollection.addSubview(refreshControl)
        }
        (imageCollection.collectionViewLayout as! UICollectionViewFlowLayout).itemSize = CGSize(width: imageSideLength, height: imageSideLength)
        
        currentIndex = 3
        
        resultsShower = UIStoryboard(name: "Mich", bundle: nil).instantiateViewController(withIdentifier: "SearchResultsViewController") as! SearchResultsViewController
        resultsShower.userChoosenDelegate = self
        searchController = UISearchController(searchResultsController: resultsShower)
        searchController.searchResultsUpdater = resultsShower
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Search Mich"
        searchController.searchBar.sizeToFit()
        searchController.definesPresentationContext = false
        searchController.hidesNavigationBarDuringPresentation = false
        self.navigationItem.titleView = searchController.searchBar
        MichTransport.explore(token: (UIApplication.shared.delegate as! AppDelegate).token!, successCallbackForexplore: onExploreSuccess, errorCallbackForexplore: onError)
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
        Nuke.loadImage(with: Foundation.URL(string: data[indexPath.item].image!)!, into: cell.photo)
        return cell
    }
    // MARK: user listener
    func gotoUserPage(id: Int) {
        self.destinationUserId = id
        performSegue(withIdentifier: "gotoprofilepage", sender: self)
        //searchController.dismiss(animated: false, completion: helper)
    }
    
    func helper() {
        searchController.isActive = false
        performSegue(withIdentifier: "gotoprofilepage", sender: self)
    }
    
    // MARK: navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if (segue.identifier == "gotoprofilepage") {
            (segue.destination as! UserPicturesCollectionViewController).userId = self.destinationUserId
            (segue.destination as! UserPicturesCollectionViewController).hidesBottomBarWhenPushed = true
        }
        else if segue.identifier == "showpost" {
            if let selectedCell = sender as? UserPicturesCollectionViewCell {
                let indexPath = imageCollection.indexPath(for: selectedCell)
                (segue.destination as! PostViewController).postId = data[(indexPath?.item)!].id
            }
        }
    }
    
    // MARK: refreshcontrol
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        MichTransport.explore(token: (UIApplication.shared.delegate as! AppDelegate).token!, successCallbackForexplore: onExploreSuccess, errorCallbackForexplore: onError)
    }
    
    // MARK: callbakcs
    func onExploreSuccess(resp: [PostClass]) {
        self.data.removeAll()
        self.data.append(contentsOf: resp)
        self.imageCollection.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.refreshControl.endRefreshing()
        })
    }
    
    func onError(error: DefaultError){
        let alert = UIAlertController(title: "Alert", message: error.errorString, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
