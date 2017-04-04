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
    @IBOutlet weak var trailing: NSLayoutConstraint!
    @IBOutlet weak var leading: NSLayoutConstraint!
    @IBOutlet weak var top: NSLayoutConstraint!
    @IBOutlet weak var bottom: NSLayoutConstraint!
    @IBOutlet weak var height: NSLayoutConstraint!
    @IBOutlet weak var width: NSLayoutConstraint!
    
    
    @IBOutlet weak var photoTextTF: UITextField!
    
    
    var first: Bool! = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EditImageViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    private func setImage(image: UIImage) {
        photo.image = img.af_imageAspectScaled(toFit: scrollView.frame.size)
        width.constant = (photo.image?.size.width)!
        height.constant = (photo.image?.size.height)!
        updateMinZoomScaleForSize(size: (photo.image?.size)!)
    }
    
    private func updateMinZoomScaleForSize(size: CGSize) {
        let widthScale = scrollView.frame.size.width / size.width
        let heightScale = scrollView.frame.size.height / size.height
        let minScale = max(widthScale, heightScale)
        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = minScale
        scrollView.maximumZoomScale = minScale * 4
        print(minScale)
    }
    
    
    @IBAction func crop(_ sender: Any) {
        
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
    
    
    
    @IBAction func photoText(_ sender: Any) {
        
        photoTextTF.becomeFirstResponder()
        photoTextTF.isHidden = false
        photoTextTF.backgroundColor = UIColor (red:243 / 255.0, green:92 / 255.0, blue:59 / 255.0, alpha:0.4)
        
    
    }
    
    @IBAction func photoTitle(_ sender: Any) {
        titleTF.becomeFirstResponder()
        titleTF.isHidden = false
    }
    
    
    @IBAction func zoomBTN(_ sender: Any) {
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .beginFromCurrentState, animations: {() -> Void in
            self.scrollView.zoomScale = self.scrollView.minimumZoomScale
        }, completion: { _ in })
        
        
        
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
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        photoTextTF.isHidden = true
        titleTF.isHidden = true
        view.endEditing(true)
    }

}
