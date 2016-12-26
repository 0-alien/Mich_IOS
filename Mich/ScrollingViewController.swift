//
//  ScrollingViewController.swift
//  Mich
//
//  Created by Gigi Pataraia on 12/6/16.
//  Copyright © 2016 Gigi. All rights reserved.
//

import UIKit

class ScrollingViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(ScrollingViewController.hideScrollingMenu), name: NSNotification.Name(rawValue: "showNotifications"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ScrollingViewController.hideScrollingMenu), name: NSNotification.Name(rawValue: "showMessages"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ScrollingViewController.hideScrollingMenu), name: NSNotification.Name(rawValue: "showSettings"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ScrollingViewController.hideScrollingMenu), name: NSNotification.Name(rawValue: "showHelp"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ScrollingViewController.enableScrolling), name: NSNotification.Name(rawValue: "enableScrolling"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ScrollingViewController.disableScrolling), name: NSNotification.Name(rawValue: "disableScrolling"), object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func disableScrolling() {
        scrollView.isScrollEnabled = false
    }
    func enableScrolling() {
        scrollView.isScrollEnabled = true
    }
    
    func hideScrollingMenu() {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollView.isPagingEnabled = true
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollView.isPagingEnabled = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
