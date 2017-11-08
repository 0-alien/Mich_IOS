//
//  MichSearchViewController.swift
//  Mich
//
//  Created by Gigi Pataraia on 10/18/16.
//  Copyright © 2016 Gigi. All rights reserved.
//

import UIKit
import Nuke

class MichSearchViewController: ViewController, UICollectionViewDataSource {
    
    private let reuseIdentifier = "UserPicturesCollectionViewCell"
    let spaceing : CGFloat = 1.0
    let itemsPerRow : CGFloat = 3.0
    var imageSideLength : CGFloat = 0.0
    var destinationPostId: Int?
    var searchController: UISearchController!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(MichSearchViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        return refreshControl
    }()
    
    
    @IBOutlet weak var imageCollection: UICollectionView!
    var posts: [PostClass] = [PostClass]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageSideLength = (self.view.frame.size.width - (itemsPerRow - 1) * spaceing)  / itemsPerRow
        if #available(iOS 10.0, *) {
            self.imageCollection.refreshControl = refreshControl
        } else {
            self.imageCollection.addSubview(refreshControl)
        }
        (imageCollection.collectionViewLayout as! UICollectionViewFlowLayout).itemSize = CGSize(width: imageSideLength, height: imageSideLength)
        
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
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! UserPicturesCollectionViewCell
        Nuke.loadImage(with: Foundation.URL(string: posts[indexPath.item].image!)!, into: cell.photo)
        return cell
    }
    
    // MARK: navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "showpost" {
            if let selectedCell = sender as? UserPicturesCollectionViewCell {
                let indexPath = imageCollection.indexPath(for: selectedCell)
                (segue.destination as! PostViewController).postId = posts[(indexPath?.item)!].id
            }
        }
    }
    
    // MARK: refreshcontrol
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        MichTransport.explore(token: (UIApplication.shared.delegate as! AppDelegate).token!, successCallbackForexplore: onExploreSuccess, errorCallbackForexplore: onError)
    }
    
    // MARK: callbakcs
    func onExploreSuccess(resp: [PostClass]) {
        var addedIndexPaths: [IndexPath] = [], removedIndexPaths: [IndexPath] = []
        for i in 0 ..< self.posts.count {
            var index: Int = -1
            for j in 0 ..< resp.count {
                if self.posts[i].id == resp[j].id {
                    index = j
                    break
                }
            }
            if index == -1 {
                removedIndexPaths.append(IndexPath(item: i, section: 0))
            }
        }
        removedIndexPaths.reverse()
        for indexPath in removedIndexPaths{
            self.posts.remove(at: indexPath.item)
        }
        self.imageCollection.deleteItems(at: removedIndexPaths)
        for i in 0 ..< resp.count {
            var index: Int = -1
            for j in 0 ..< self.posts.count {
                if resp[i].id == self.posts[j].id {
                    index = j
                    break
                }
            }
            if index == -1 {
                addedIndexPaths.append(IndexPath(item: i, section: 0))
            }
        }
        for indexPath in addedIndexPaths {
            self.posts.insert(resp[indexPath.item], at: indexPath.item)
        }
        self.imageCollection.insertItems(at: addedIndexPaths)
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
