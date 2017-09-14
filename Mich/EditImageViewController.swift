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
    
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var textOfImage: UITextField!
    
    
    var rw: CGFloat = 0
    var rh: CGFloat = 0
    
    var first: Bool! = true
    
    
    var panGets = UIPanGestureRecognizer()
    
    var textOfImageShow: Bool! = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textOfImage.delegate = self
        photo.image = photo.image?.fixedOrientation()
        img = img.fixedOrientation()
        doneButtone.isEnabled = true
        panGets = UIPanGestureRecognizer.init(target: self, action: #selector(handlePan(_:)))
        textOfImage.addGestureRecognizer(panGets)
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EditImageViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setImageToCrop(image: img)
        updateConstraintsForSize(scrollView.bounds.size)
    }
    
    
    @IBAction func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            
            let translation = gestureRecognizer.translation(in: self.view)
            // note: 'view' is optional and need to be unwrapped
            gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x + translation.x, y: gestureRecognizer.view!.center.y + translation.y)
            gestureRecognizer.setTranslation(CGPoint.zero, in: self.view)
        }
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
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateConstraintsForSize(scrollView.bounds.size);
    }
    
    fileprivate func updateConstraintsForSize(_ size: CGSize) {
        
        let yOffset = max(0, (size.height - photo.frame.height) / 2)
        imageViewTopConstraint.constant = yOffset
        imageViewBottomConstraint.constant = yOffset
        
        let xOffset = max(0, (size.width - photo.frame.width) / 2)
        imageViewLeadingConstraint.constant = xOffset
        imageViewTrailingConstraint.constant = xOffset
        
        view.layoutIfNeeded()
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
        photo.image = photo.image?.fixedOrientation()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
        
        /*
        let renderer = UIGraphicsImageRenderer(size: scrollView.bounds.size)
        let image = renderer.image { ctx in
            view.drawHierarchy(in: scrollView.bounds, afterScreenUpdates: true)
        }
        photo.image = image
        */
        
        if segue.identifier == "tagimage" {
            photo.image = photo.image?.fixedOrientation()
            let scale:CGFloat = 1 / scrollView.zoomScale
            let x:CGFloat = scrollView.contentOffset.x * scale
            let y:CGFloat = scrollView.contentOffset.y * scale
            let width:CGFloat = scrollView.frame.size.width * scale
            let height:CGFloat = scrollView.frame.size.height * scale
            let croppedCGImage = photo.image?.cgImage?.cropping(to: CGRect(x: x, y: y, width: width, height: height))
            let croppedImage = UIImage(cgImage: croppedCGImage!).fixedOrientation()
            (segue.destination as! TagImageViewController).image = croppedImage
        }
        
        
        
    }
    

    @IBAction func zoomBTN(_ sender: Any) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .beginFromCurrentState, animations: {() -> Void in
            self.scrollView.zoomScale = self.scrollView.minimumZoomScale
        }, completion: { _ in })
    }
    
    
    @IBAction func addTextBTN(_ sender: Any) {
        if(!textOfImageShow){
            textOfImage.isHidden = false;
            textOfImageShow = true
        }else{
            textOfImage.isHidden = true
            textOfImageShow = false;
        }
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
