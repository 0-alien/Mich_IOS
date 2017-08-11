//
//  TagImageViewController.swift
//  Mich
//
//  Created by Gigi Pataraia on 7/26/17.
//  Copyright © 2017 Lemon. All rights reserved.
//

import UIKit

class TagImageViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var photo: UIImageView!
    var image: UIImage!
    @IBOutlet weak var writeACaptionTextView: UITextView!
    var placeholderLabel : UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        writeACaptionTextView.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "Write A Caption.."
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: (writeACaptionTextView.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        writeACaptionTextView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (writeACaptionTextView.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !writeACaptionTextView.text.isEmpty
        photo.image = image
    }

    
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        writeACaptionTextView.becomeFirstResponder()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func post(_ sender: Any) {
        var title = writeACaptionTextView.text
        if title == nil {
            title = " ";
        }
        MichTransport.createpost(token: (UIApplication.shared.delegate as! AppDelegate).token!, title: title!, image: self.image, successCallbackForCreatePost: onSuccess, errorCallbackForCreatePost: onError)
    }
    
    // MARK: callbacks
    func onSuccess() {
        self.tabBarController?.selectedIndex = 0
        ((self.tabBarController?.viewControllers?[0] as! UINavigationController).viewControllers[0] as! PostsViewController).tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        _ = self.navigationController?.popToRootViewController(animated: false)
    }
    
    func onError(error: DefaultError) {
        let alert = UIAlertController(title: "Alert", message: error.errorString, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
