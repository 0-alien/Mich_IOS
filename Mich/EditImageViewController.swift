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
    @IBOutlet weak var doneButtone: UIBarButtonItem!
    var postTitle: String?
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    var rw: CGFloat = 0
    var rh: CGFloat = 0
    
    var first: Bool! = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UIImageJPEGRepresentation(img, 1.0)
        
        
        photo.image = photo.image?.fixedOrientation()
        img = img.fixedOrientation()
        
        setImageToCrop(image: img)
        doneButtone.isEnabled = true
    }
    
    

    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateScrollViewZooms()
    }
    
    func setImageToCrop(image:UIImage){
        
        photo.image = image.fixedOrientation()
        updateScrollViewZooms()
    }
    
    func updateScrollViewZooms() {
        scrollView.minimumZoomScale = min(scrollView.frame.size.width / (photo.image?.size.width)!, scrollView.frame.size.height / (photo.image?.size.height)!)
        scrollView.zoomScale = min(scrollView.frame.size.width / (photo.image?.size.width)!, scrollView.frame.size.height / (photo.image?.size.height)!)
        scrollView.maximumZoomScale = min(scrollView.frame.size.width / (photo.image?.size.width)!, scrollView.frame.size.height / (photo.image?.size.height)!) * 5
    }
    
    
    
    
    
    @IBAction func crop(_ sender: Any) {
        photo.image = photo.image?.fixedOrientation()
        let scale:CGFloat = 1 / scrollView.zoomScale
        let x:CGFloat = scrollView.contentOffset.x * scale
        let y:CGFloat = scrollView.contentOffset.y * scale
        let width:CGFloat = scrollView.frame.size.width * scale
        let height:CGFloat = scrollView.frame.size.height * scale
        let croppedCGImage = photo.image?.cgImage?.cropping(to: CGRect(x: x, y: y, width: width, height: height))
        let croppedImage = UIImage(cgImage: croppedCGImage!).fixedOrientation()
        
//        UIImageJPEGRepresentation(croppedImage, 1)
        
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
    
    
    /////////////////////////////////// postis tittle igzavneba rogorc carieli, saertod ar unda gaigzavnos, shesacvlelia!!!!!!!
    
    @IBAction func done(_ sender: Any) {
        doneButtone.isEnabled = false
        
/*
        if((photo.image?.size.width)! < (photo.image?.size.height)!){
            print((photo.image?.size.width)!)
            print((photo.image?.size.height)!)
            photo.image = photo.image?.rotateImageByDegrees(90)
            
        }
*/
        
        photo.image = photo.image?.fixedOrientation()
        
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       textField.resignFirstResponder()
        done(self)
        return true
 
    }

    /*
    func checkValidTitle() {
        let text = titleTF.text ?? ""
        doneButtone.isEnabled = !text.isEmpty
        
    }
     */
    
    func textFieldDidEndEditing(_ textField: UITextField) {

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
}
