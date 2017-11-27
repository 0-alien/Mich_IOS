//
//  MichHomeViewController.swift
//  Mich
//
//  Created by Gigi Pataraia on 8/10/17.
//  Copyright © 2017 Lemon. All rights reserved.
//

import UIKit

class MichHomeViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UserListener, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var viewControllerList: [UIViewController] = [UIViewController]()
    var searchController: UISearchController!
    var resultsShower: SearchResultsViewController!
    var currentViewController: UIViewController! = nil
    var destinationUserId: Int!
    
    var currentIndex = 0
    var vv: Camera!
    var isCameraShown: Bool = false
    var cameraPhoto: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.currentIndex = 4
        self.isCameraShown = false

        NotificationCenter.default.addObserver(self, selector: #selector(SlidingMenuPresentingViewController.cameraClicked), name: NSNotification.Name(rawValue: "showChoose"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SlidingMenuPresentingViewController.hideChoose), name: NSNotification.Name(rawValue: "hideChoose"), object: nil)

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
        searchController.definesPresentationContext = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.isHidden = false

        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.topItem?.titleView = searchController.searchBar
        } else {
            self.navigationItem.titleView = searchController.searchBar
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if currentViewController == nil {
            currentViewController = self.viewControllerList.first
            setViewControllers([currentViewController], direction: .forward, animated: true, completion: nil)
        }
        (tabBarController as! MainTabBarController).savedIndex = currentIndex
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
            let index = viewControllerList.index(of: previousViewControllers.first!)
            if index == 0 {
                //searchController.searchBar.isHidden = true
                currentViewController = self.viewControllerList[1]
            } else {
                //searchController.searchBar.isHidden = false
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "gotoprofilepage" {
            (segue.destination as! UserPicturesCollectionViewController).userId = self.destinationUserId
        }
        if (segue.identifier == "gotoeditimage") {
            (segue.destination as! EditImageViewController).img = self.cameraPhoto
        }
    }
 
    
    
    func cameraClicked() {
        if ((tabBarController as! MainTabBarController).savedIndex == currentIndex) {
            if (self.isCameraShown) {
                hideChoose()
            }
            else {
                self.isCameraShown = true
                NotificationCenter.default.post(name: Notification.Name(rawValue: "disableScrolling"), object: nil)
                vv = Camera(frame: self.view.bounds)
                vv.backgroundColor = UIColor.black.withAlphaComponent(0.3)
                vv.gallery.addTarget(self, action: #selector(self.libr(_:)), for: .touchUpInside)
                vv.camera.addTarget(self, action: #selector(self.camera(_:)), for: .touchUpInside)
                self.view.addSubview(vv)
            }
        }
    }
    
    func hideChoose() {
        if ((tabBarController as! MainTabBarController).savedIndex == currentIndex) {
            if (self.isCameraShown) {
                self.isCameraShown = false
                NotificationCenter.default.post(name: Notification.Name(rawValue: "enableScrolling"), object: nil)
                vv.removeFromSuperview()
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if (isCameraShown) {
            hideChoose()
        }
    }
    
    //----------- CAMERA -------
    func camera(_ sender: AnyObject) {
        vv.removeFromSuperview()
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func libr(_ sender: AnyObject) {
        vv.removeFromSuperview()
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!){
        self.cameraPhoto = image
        self.dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: "gotoeditimage", sender: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "disableScrolling"), object: nil)
        
    }


}
