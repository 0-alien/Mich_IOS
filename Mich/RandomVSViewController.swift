//
//  RandomVSViewController.swift
//  Mich
//
//  Created by Gigi Pataraia on 7/12/17.
//  Copyright © 2017 Lemon. All rights reserved.
//

import UIKit

class RandomVSViewController: UIViewController {

    @IBOutlet weak var hostImage: UIImageView!
    @IBOutlet weak var guestImage: UIImageView!
    @IBOutlet weak var hostUsername: UILabel!
    @IBOutlet weak var guestUsername: UILabel!
    var destinationBattle: Battle!
    var isSpectate: Bool! = false
    var cancelled: Bool! = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hostImage.image = hostImage.image?.af_imageRounded(withCornerRadius: 15)
        guestImage.image = guestImage.image?.af_imageRounded(withCornerRadius: 15)
        
        hostUsername.text = (UIApplication.shared.delegate as! AppDelegate).user?.username
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - actions
    @IBAction func startSearch(_ sender: Any) {
        self.navigationItem.leftBarButtonItem?.isEnabled = true
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        guestImage.animationImages = [
            UIImage(named: "Image")!,
            UIImage(named: "Image-1")!,
            UIImage(named: "Image-2")!
            
        ]
        guestImage.animationDuration = 0.3
        guestImage.startAnimating()
        guestUsername.text = "Searching..."
        if isSpectate {
            hostImage.animationImages = [
                UIImage(named: "Image")!,
                UIImage(named: "Image-1")!,
                UIImage(named: "Image-2")!
            ]
            hostImage.animationDuration = 0.3
            hostImage.startAnimating()
            hostUsername.text = "Searching..."
        }
        
        if isSpectate {
            MichVSTransport.getRandomBattle(token: (UIApplication.shared.delegate as! AppDelegate).token!, successCallbackForGetRandomBattle: onSuccess, errorCallbackForGetRandomBattle: onError)
        } else {
            MichVSTransport.playRandomBattle(token: (UIApplication.shared.delegate as! AppDelegate).token!, successCallbackForPlayRandomBattle: onSuccess, errorCallbackForPlayRandomBattle: onError)
        }
    }

    @IBAction func cancelSearch(_ sender: Any) {
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        cancelled = true
        self.guestImage.stopAnimating()
        if isSpectate {
            self.hostImage.stopAnimating()
        }
        MichVSTransport.cancelPlay(token: (UIApplication.shared.delegate as! AppDelegate).token!, successCallbackForCancelPlay: onCancelPlaySuccess, errorCallbackForCancelPlay: onCancelPlayError)
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: - navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showbattle" {
            (segue.destination as! ChatContainerViewController).battleId = self.destinationBattle.id
        }
    }
    // MARK: - callbacks
    func onCancelPlaySuccess() {
        
    }
    
    func onCancelPlayError(error: DefaultError) {
        let alert = UIAlertController(title: "Alert", message: error.errorString, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func onSuccess(battle: Battle) {
        if cancelled {
            return
        } else {
            self.navigationItem.leftBarButtonItem?.isEnabled = false
            self.destinationBattle = battle
            let when = DispatchTime.now() + 2 // change 2 to desired number of seconds
            DispatchQueue.main.asyncAfter(deadline: when) {

                self.guestImage.stopAnimating()
                self.guestUsername.text = self.destinationBattle.guest?.username
                self.guestImage.af_setImage(withURL: Foundation.URL(string: (self.destinationBattle.guest?.avatar)!)!)
                
                if self.isSpectate {
                    self.hostImage.stopAnimating()
                    self.hostUsername.text = self.destinationBattle.host?.username
                    self.hostImage.af_setImage(withURL: Foundation.URL(string: (self.destinationBattle.host?.avatar)!)!)
                }
                self.performSegue(withIdentifier: "showbattle", sender: self)
            }
        }
    }
    
    func onError(error: DefaultError) {
        if cancelled {
            return
        }
        if isSpectate {
            if error.code == 22 {
                let when = DispatchTime.now() + 2 // change 2 to desired number of seconds
                DispatchQueue.main.asyncAfter(deadline: when) {
                    if self.cancelled {
                        return
                    }
                    MichVSTransport.getRandomBattle(token: (UIApplication.shared.delegate as! AppDelegate).token!, successCallbackForGetRandomBattle: self.onSuccess, errorCallbackForGetRandomBattle: self.onError)
                }
                return
            }
        } else {
            if error.code == 40 {
                let when = DispatchTime.now() + 2 // change 2 to desired number of seconds
                DispatchQueue.main.asyncAfter(deadline: when) {
                    if self.cancelled {
                        return
                    }
                    MichVSTransport.playRandomBattle(token: (UIApplication.shared.delegate as! AppDelegate).token!, successCallbackForPlayRandomBattle: self.onSuccess, errorCallbackForPlayRandomBattle: self.onError)
                }
                return
            }
        }
        let alert = UIAlertController(title: "Alert", message: error.errorString, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
