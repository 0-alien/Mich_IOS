//
//  ChatContainerViewController.swift
//  Mich
//
//  Created by Gigi Pataraia on 11/9/17.
//  Copyright © 2017 Lemon. All rights reserved.
//

import UIKit
import Nuke
import Firebase

class ChatContainerViewController: UIViewController, MessageDelegate {

    var battleId: Int!
    var battle: Battle?
    
    var timer: Timer!
    @IBOutlet weak var timerLabel: UILabel!
    var channelRef: FIRDatabaseReference?
    private var voteRef: FIRDatabaseReference!
    private var newVoteRefHandle: FIRDatabaseHandle?
    private var voteAddedRefHandle: FIRDatabaseHandle?
    private var reverse: Bool! = false
    
    @IBOutlet weak var rightPointCountLabel: UILabel!
    @IBOutlet weak var leftPointCountLabel: UILabel!
    @IBOutlet weak var rightImage: UIImageView!
    @IBOutlet weak var leftImage: UIImageView!
    
    
    var secondsLeft: Int!
    var finishable: Finishable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        channelRef = FIRDatabase.database().reference() //connect to database
        MichVSTransport.getBattle(token: (UIApplication.shared.delegate as! AppDelegate).token!, battleId: self.battleId, successCallbackForGetBattle: onGetBattleSuccess, errorCallbackForGetBattle: onError)
        self.secondsLeft = 0
        self.rightImage = self.rightImage.circle
        self.leftImage = self.leftImage.circle
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.removeObservers()
    }
    // MARK: - navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "embedchat" {
            self.finishable = (segue.destination as! VSJSQViewController)
            (segue.destination as! VSJSQViewController).messageDelegate = self
            (segue.destination as! VSJSQViewController).battleId = self.battleId
            (segue.destination as! VSJSQViewController).senderId = String(((UIApplication.shared.delegate as! AppDelegate).user?.id)! + 0)
            (segue.destination as! VSJSQViewController).senderDisplayName = (UIApplication.shared.delegate as! AppDelegate).user?.username
        }
    }
    // MARK: - class methods
    private func loadBattle(battle: Battle) {
        self.battle = battle
        if battle.iAmGuest! {
            Nuke.loadImage(with: Foundation.URL(string: (battle.host?.avatar)!)!, into: self.leftImage) // piriqit aris suratebi
            Nuke.loadImage(with: Foundation.URL(string: (battle.guest?.avatar)!)!, into: self.rightImage)
            self.leftPointCountLabel.text = String((battle.host?.votes)! + 0)
            self.rightPointCountLabel.text = String((battle.guest?.votes)! + 0)
        } else {
            Nuke.loadImage(with: Foundation.URL(string: (battle.host?.avatar)!)!, into: self.rightImage) // piriqit aris suratebi
            Nuke.loadImage(with: Foundation.URL(string: (battle.guest?.avatar)!)!, into: self.leftImage)
            self.rightPointCountLabel.text = String((battle.host?.votes)! + 0)
            self.leftPointCountLabel.text = String((battle.guest?.votes)! + 0)
        }
        self.secondsLeft = self.battle?.secondsLeft
        if self.battle?.status != 0 {
            self.startObserving(status: (self.battle?.status)!)
        }
    }
    func update() {
        if self.secondsLeft == 0 {
            self.timer.invalidate()
            self.timerLabel.textColor = UIColor.red
            self.finishable?.finish()
            return
        }
        self.secondsLeft = self.secondsLeft - 1
        if self.secondsLeft < 30 && self.secondsLeft != 0 {
            self.timerLabel.textColor = UIColor.red
        }
        self.timerLabel.text = ""
        if self.secondsLeft / 60 < 10 {
            self.timerLabel.text = "0"
        }
        self.timerLabel.text = self.timerLabel.text! + String(self.secondsLeft / 60) + ":"
        if self.secondsLeft % 60 < 10 {
            self.timerLabel.text = self.timerLabel.text! + "0"
        }
        self.timerLabel.text = self.timerLabel.text! + String(self.secondsLeft % 60)
    }
    // MARK: - message delegate
    func startObserving(status: Int) {
        self.battle?.status = status
        if battle?.status == 1 {
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        }
        voteRef = self.channelRef!.child(String(self.battleId)).child("votes")
        voteAddedRefHandle = voteRef.observe(.childAdded, with: { (snapshot) -> Void in
            if let val = snapshot.value as? Int {
                if (snapshot.key == "host") {
                    if (self.battle?.iAmGuest)! {
                        self.battle?.host?.votes = val
                        self.leftPointCountLabel.text = String((self.battle?.host?.votes)! + 0)
                    } else {
                        self.battle?.host?.votes = val
                        self.rightPointCountLabel.text = String((self.battle?.host?.votes)! + 0)
                    }
                } else if (snapshot.key == "guest") {
                    if (self.battle?.iAmGuest)! {
                        self.battle?.guest?.votes = val
                        self.rightPointCountLabel.text = String((self.battle?.guest?.votes)! + 0)
                    } else {
                        self.battle?.guest?.votes = val
                        self.leftPointCountLabel.text = String((self.battle?.guest?.votes)! + 0)
                    }
                } else {
                    print("Error! Could not decode channel data")
                }
            }
        })
        newVoteRefHandle = voteRef.observe(.childChanged, with: { (snapshot) -> Void in
            if let val = snapshot.value as? Int {
                if (snapshot.key == "host") {
                    if (self.battle?.iAmGuest)! {
                        self.battle?.host?.votes = val
                        self.leftPointCountLabel.text = String((self.battle?.host?.votes)! + 0)
                    } else {
                        self.battle?.host?.votes = val
                        self.rightPointCountLabel.text = String((self.battle?.host?.votes)! + 0)
                    }
                } else if (snapshot.key == "guest") {
                    if (self.battle?.iAmGuest)! {
                        self.battle?.guest?.votes = val
                        self.rightPointCountLabel.text = String((self.battle?.guest?.votes)! + 0)
                    } else {
                        self.battle?.guest?.votes = val
                        self.leftPointCountLabel.text = String((self.battle?.guest?.votes)! + 0)
                    }
                } else {
                    print("Error! Could not decode channel data")
                }
            }
        })
    }
    
    func didCancel() {
        self.dismiss(animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    func removeObservers() {
        if let rr = newVoteRefHandle {
            voteRef.removeObserver(withHandle: rr)
        }
        if let rr = voteAddedRefHandle {
            voteRef.removeObserver(withHandle: rr)
        }
    }
    // MARK: - actions
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func didVoteForHost(_ sender: Any) {
        if self.battle?.status == 1 {
            if ((battle?.iAmGuest)! && (battle?.myBattle)!) {
                MichVSTransport.vote(token: (UIApplication.shared.delegate as! AppDelegate).token!, battleId: self.battleId, host: 1,
                                     successCallbackForVote: {self.voteRef.child("host").setValue((self.battle?.host?.votes)! + 1)}, errorCallbackForVote: onError)
            } else {
                MichVSTransport.vote(token: (UIApplication.shared.delegate as! AppDelegate).token!, battleId: self.battleId, host: 0,
                                     successCallbackForVote: {self.voteRef.child("guest").setValue((self.battle?.guest?.votes)! + 1)}, errorCallbackForVote: onError)
            }
        }
        
    }
    @IBAction func didVoteForGuest(_ sender: Any) {
        if self.battle?.status == 1 {
            if ((battle?.iAmGuest)! && (battle?.myBattle)!) {
                MichVSTransport.vote(token: (UIApplication.shared.delegate as! AppDelegate).token!, battleId: self.battleId, host: 0,
                                     successCallbackForVote: {self.voteRef.child("guest").setValue((self.battle?.guest?.votes)! + 1)}, errorCallbackForVote: onError)
            } else {
                MichVSTransport.vote(token: (UIApplication.shared.delegate as! AppDelegate).token!, battleId: self.battleId, host: 1,
                                     successCallbackForVote: {self.voteRef.child("host").setValue((self.battle?.host?.votes)! + 1)}, errorCallbackForVote: onError)
            }
        }
    }
    // MARK: - callbacks
    private func onGetBattleSuccess(battle: Battle) {
        self.loadBattle(battle: battle)
    }
    func onError(error: DefaultError) {
        let alert = UIAlertController(title: "Alert", message: error.errorString, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

protocol MessageDelegate {
    func startObserving(status: Int)
    func didCancel()
}
protocol Finishable {
    func finish()
}
