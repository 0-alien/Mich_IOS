//
//  RandomVSViewController.swift
//  Mich
//
//  Created by Gigi Pataraia on 7/12/17.
//  Copyright © 2017 Lemon. All rights reserved.
//

import Nuke
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
        hostImage.image = hostImage.image?.circle
        guestImage.image = guestImage.image?.circle
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationItem.leftBarButtonItem?.isEnabled = true
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        if !self.isSpectate {
            Nuke.loadImage(with: Foundation.URL(string: ((UIApplication.shared.delegate as! AppDelegate).user?.avatar)!)!, into: self.hostImage)
            hostUsername.text = (UIApplication.shared.delegate as! AppDelegate).user?.username
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - actions
    @IBAction func startSearch(_ sender: Any) {
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        guestImage.animationImages = [
            
            UIImage(named: "first_user")!,
            UIImage(named: "profile1")!,
            UIImage(named: "profile")!,
            UIImage(named: "profile4")!,
            UIImage(named: "second_user")!
            
        ]
        guestImage.animationDuration = 0.3
        guestImage.startAnimating()
        guestUsername.text = "Searching..."
        if isSpectate {
            hostImage.animationImages = [
                UIImage(named: "profile1")!,
                UIImage(named: "second_user")!,
                UIImage(named: "first_user")!,
                UIImage(named: "profile4")!,
                UIImage(named: "profile")!
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
                if battle.iAmHost! {
                    self.guestUsername.text = self.destinationBattle.guest?.username
                    Nuke.loadImage(with: Foundation.URL(string: (self.destinationBattle.guest?.avatar)!)!, into: self.guestImage)
                } else {
                    self.guestUsername.text = self.destinationBattle.host?.username
                    Nuke.loadImage(with: Foundation.URL(string: (self.destinationBattle.host?.avatar)!)!, into: self.guestImage)
                }
                
                if self.isSpectate {
                    self.hostImage.stopAnimating()
                    self.hostUsername.text = self.destinationBattle.host?.username
                    Nuke.loadImage(with: Foundation.URL(string: (self.destinationBattle.host?.avatar)!)!, into: self.hostImage)
                }
                let when = DispatchTime.now() + 3 // change 2 to desired number of seconds
                DispatchQueue.main.asyncAfter(deadline: when) {
                // Your code with delay
                    self.performSegue(withIdentifier: "showbattle", sender: self)
                }
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
