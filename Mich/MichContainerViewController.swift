//
//  MichContainerViewController.swift
//  Mich
//
//  Created by Gigi Pataraia on 11/20/17.
//  Copyright © 2017 Lemon. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class MichContainerViewController: ButtonBarPagerTabStripViewController {

    override func viewDidLoad() {
        settings.style.buttonBarBackgroundColor = UIColor.white
        settings.style.buttonBarItemBackgroundColor = UIColor.white
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarItemTitleColor = UIColor.red
        settings.style.buttonBarMinimumInteritemSpacing = 0
        settings.style.selectedBarHeight = 1
        settings.style.selectedBarBackgroundColor = UIColor.red
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override public func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let vc1: MichSearchViewController = UIStoryboard(name: "Mich", bundle: nil).instantiateViewController(withIdentifier: "Search") as! MichSearchViewController
        let vc2: MichSwipePhotosViewController = UIStoryboard(name: "Mich", bundle: nil).instantiateViewController(withIdentifier: "Tinder") as! MichSwipePhotosViewController
        return [vc1, vc2]
    }
}
