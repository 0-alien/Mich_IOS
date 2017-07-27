//
//  TagImageViewController.swift
//  Mich
//
//  Created by Gigi Pataraia on 7/26/17.
//  Copyright © 2017 Lemon. All rights reserved.
//

import UIKit

class TagImageViewController: UIViewController, UITextViewDelegate {
    
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
        
        
        

        // Do any additional setup after loading the view.
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
