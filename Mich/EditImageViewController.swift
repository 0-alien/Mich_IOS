//
//  EditImageViewController.swift
//  Mich
//
//  Created by Gigi Pataraia on 2/16/17.
//  Copyright © 2017 Gigi. All rights reserved.
//

import UIKit

class EditImageViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {

    @IBOutlet weak var photo: UIImageView!
    var img: UIImage!
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var doneButtone: UIBarButtonItem!
    var postTitle: String?
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    
    override func viewDidLoad() {
        
        titleTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        super.viewDidLoad()
        photo.image = img
        
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 3.0
        
        
    }
    
    
    @IBAction func crop(_ sender: Any) {
        
    scrollView.zoomScale = 1
        let croppedCGImage = photo.image?.cgImage?.cropping(to: photo.imageFrame())
        print(photo.imageFrame())
        print(photo.frame)
        print(croppedCGImage?.width)
        print(croppedCGImage?.height)
        let croppedImage = UIImage(cgImage: croppedCGImage!)
        photo.image = croppedImage
    
    }
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.photo
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func done(_ sender: Any) {
        doneButtone.isEnabled = false
        MichTransport.createpost(token: (UIApplication.shared.delegate as! AppDelegate).token!, title: postTitle!, image: img!,
                                 successCallbackForCreatePost: self.oncreatesuccess, errorCallbackForCreatePost: self.oncreateerror)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        done(self)
        return true
    }
    
    func checkValidTitle() {
        let text = titleTF.text ?? ""
        doneButtone.isEnabled = !text.isEmpty
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        checkValidTitle()
//        postTitle = titleTF.text
        
        
        
    }
    
    
    func textFieldDidChange(_ textField: UITextField) {
        if(titleTF.text!  == ""){
            
            doneButtone.isEnabled = false;
        }else{
            
            doneButtone.isEnabled = true;
            postTitle = titleTF.text
        }
    }
    
    
    
    //Mark: oncreate callbacks
    
    func oncreatesuccess() {
        self.tabBarController?.selectedIndex = 0
        ((self.tabBarController?.viewControllers?[0] as! UINavigationController).viewControllers[0] as! PostsViewController).tableView.setContentOffset(CGPoint.zero, animated: true)
        ((self.tabBarController?.viewControllers?[0] as! UINavigationController).viewControllers[0] as! PostsViewController).handleRefresh(((self.tabBarController?.viewControllers?[0] as! UINavigationController).viewControllers[0] as! PostsViewController).tableView.refreshControl!)
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func oncreateerror(error: DefaultError) {
        let alert = UIAlertController(title: "Alert", message: error.errorString, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
