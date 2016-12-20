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
    
    @IBOutlet weak var imageCollection: UICollectionView!
    
    var data = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        currentIndex = 3
        
        imageSideLength = (self.view.frame.size.width - (itemsPerRow - 1) * spaceing)  / itemsPerRow
        
        for _ in 0 ..< 3 {
            for _ in 0 ..< 30 {
                data.append("login_background")
            }
        }
        // Do any additional setup after loading the view.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
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
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: imageSideLength, height: imageSideLength)
    }
    
}
