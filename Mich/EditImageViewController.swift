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
    @IBOutlet weak var photoTextTF: UITextField!
    
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    
    var rw: CGFloat = 0
    var rh: CGFloat = 0
    
    var first: Bool! = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EditImageViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setImageToCrop(image: img)
    }
    
    func setImageToCrop(image:UIImage){
        super.view.layoutIfNeeded()
        let scale: CGFloat = min(scrollView.frame.size.width / image.size.width, scrollView.frame.size.height / image.size.height)
        rw = (scrollView.frame.size.width - image.size.width * scale) / 2
        rh = (scrollView.frame.size.height - image.size.height * scale) / 2
        photo.image = image.af_imageAspectScaled(toFit: scrollView.frame.size)
        imageWidth.constant = (photo.image?.size.width)!
        imageHeight.constant = (photo.image?.size.height)!
        scrollView.minimumZoomScale = 1
        scrollView.zoomScale = 1
        scrollView.maximumZoomScale = 3
        super.view.layoutIfNeeded()
    }
    
    @IBAction func crop(_ sender: Any) {
        let scale:CGFloat = 1 / scrollView.zoomScale
        var x:CGFloat = max(scrollView.contentOffset.x * scale, rw)
        var y:CGFloat = max(scrollView.contentOffset.y * scale, rh)
        let leftLen: CGFloat = max(rw - scrollView.contentOffset.x * scale, 0)
        var rightLen: CGFloat = 0
        let upLen: CGFloat = max(rh - scrollView.contentOffset.y * scale, 0)
        var downLen: CGFloat = 0
        
        /*
         rw                                                                     -> witeli nawilis sigane
         (scrollView.frame.size.width - 2 * rw)                                 -> suratis sigane
         (scrollView.contentOffset.x + scrollView.frame.size.width) * scale     -> suratis ra nawili chans
         */
        if (rw + (scrollView.frame.size.width - 2 * rw) < (scrollView.contentOffset.x + scrollView.frame.size.width) * scale) {
            rightLen = (scrollView.contentOffset.x + scrollView.frame.size.width) * scale - (rw + (scrollView.frame.size.width - 2 * rw))
        }
        if (rh + (scrollView.frame.size.height - 2 * rh) < (scrollView.contentOffset.y + scrollView.frame.size.height) * scale) {
            downLen = (scrollView.contentOffset.y + scrollView.frame.size.height) * scale - (rh + (scrollView.frame.size.height - 2 * rh))
        }
        let width:CGFloat = (scrollView.frame.size.width * scale - leftLen - rightLen) * (photo.image?.scale)!
        let height:CGFloat = (scrollView.frame.size.height * scale - upLen - downLen) * (photo.image?.scale)!
        x = x * (photo.image?.scale)!
        y = y * (photo.image?.scale)!
        let croppedCGImage = photo.image?.cgImage?.cropping(to: CGRect(x: x, y: y, width: width, height: height))
        var croppedImage = UIImage(cgImage: croppedCGImage!)
        if((photo.image?.size.width)! < (photo.image?.size.height)!){
            croppedImage = croppedImage.rotateImageByDegrees(90)
        }
        setImageToCrop(image: croppedImage)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.photo
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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

        UIView.animate(withDuration: 0.2, delay: 0, options: .beginFromCurrentState, animations: {() -> Void in
            
            self.scrollView.zoomScale = self.scrollView.minimumZoomScale
            
        }, completion: { _ in })

    }
 
    //Mark: oncreate callbacks
    func oncreatesuccess() {
        
        self.tabBarController?.selectedIndex = 0
        
        ((self.tabBarController?.viewControllers?[0] as! UINavigationController).viewControllers[0] as! PostsViewController).tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        
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
