//
//  UserPicturesCollectionViewController.swift
//  Mich
//
//  Created by Gigi Pataraia on 9/30/16.
//  Copyright © 2016 Gigi. All rights reserved.
//

import UIKit

class UserPicturesCollectionViewController: SlidingMenuPresentingViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private let reuseIdentifier = "UserPicturesCollectionViewCell"
    let spaceing : CGFloat = 1.0
    let itemsPerRow : CGFloat = 3.0
    var imageSideLength : CGFloat = 0.0
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var profileDetailsView: UIView!
    @IBOutlet weak var imageCollection: UICollectionView!
    
    var data = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        currentIndex = 4
        
        imageSideLength = (self.view.frame.size.width - (itemsPerRow - 1) * spaceing)  / itemsPerRow
        
        for _ in 0 ..< 3 {
            for _ in 0 ..< 30 {
                data.append("login_background")
            }
        }
        profilePicture.image = profilePicture.image?.circle
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: UICollectionViewDataSource

     func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
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
