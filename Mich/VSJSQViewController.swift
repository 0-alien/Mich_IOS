//
//  VSJSQViewController.swift
//  Mich
//
//  Created by Gigi Pataraia on 6/6/17.
//  Copyright © 2017 Lemon. All rights reserved.
//

import UIKit
import Firebase
import JSQMessagesViewController
import ObjectMapper
import AlamofireImage

class VSJSQViewController: JSQMessagesViewController, JSQMessagesCollectionViewCellDelegate {

    var channelRef: FIRDatabaseReference?
    var battle: Battle!
    var battleId: Int!
    var messages = [JSQMessage]()
    
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    
    @IBOutlet weak var hostImage: UIImageView!
    @IBOutlet weak var guestImage: UIImageView!
    @IBOutlet weak var hostPointCountLabel: UILabel!
    @IBOutlet weak var guestPointCountLabel: UILabel!
    
    private lazy var messageRef: FIRDatabaseReference = self.channelRef!.child(String(self.battleId))
    private var newMessageRefHandle: FIRDatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        self.guestImage = self.guestImage.circle
        self.hostImage = self.hostImage.circle
        
        channelRef = FIRDatabase.database().reference() //connect to database
        if battle == nil {
            MichVSTransport.getBattle(token: (UIApplication.shared.delegate as! AppDelegate).token!, battleId: self.battleId, successCallbackForGetBattle: onGetBattleSuccess, errorCallbackForGetBattle: onError)
        }
        else {
            loadBattle(battle: self.battle)
        }
    }
    
    deinit {
        if let rr = self.newMessageRefHandle {
            messageRef.removeObserver(withHandle: rr)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.navigationController?.navigationBar.backgroundColor = self.navigationController?.navigationBar.backgroundColor?.withAlphaComponent(1)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: JSQ collectionView delegate
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.item]
        
        if message.senderId == senderId {
            cell.textView?.textColor = UIColor.white
        } else {
            cell.textView?.textColor = UIColor.black
        }
        cell.delegate = self
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }
    
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item]
        if message.senderId == senderId {
            return outgoingBubbleImageView
        } else {
            return incomingBubbleImageView
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    private func addMessage(withId id: String, name: String, text: String) {
        if let message = JSQMessage(senderId: id, displayName: name, text: text) {
            messages.append(message)
        }
    }

    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        let itemRef = messageRef.childByAutoId()
        let msg = BattleMessage(id: itemRef.key, senderId: Int(self.senderId)!, senderDisplayName: self.senderDisplayName, text: text)
        itemRef.setValue(msg.toJSON())
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        finishSendingMessage()
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        
    }
    
    func loadBattle(battle: Battle) {
        self.hostImage.af_setImage(withURL: Foundation.URL(string: (battle.host?.avatar)!)!)
        self.guestImage.af_setImage(withURL: Foundation.URL(string: (battle.guest?.avatar)!)!)
        if !battle.myBattle! {
            self.inputToolbar.contentView.textView.isEditable = false
            self.inputToolbar.isHidden = true
            // self.inputToolbar.removeFromSuperview() warning
        }
        if battle.status == 0 && battle.myBattle! {
            let alert = UIAlertController(title: "Alert", message: "Accept battle with " + (battle.host?.username)!, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Yes", style: .default) {
                UIAlertAction in
                MichVSTransport.acceptBattle(token: (UIApplication.shared.delegate as! AppDelegate).token!, battleId: self.battleId,
                    successCallbackForAcceptBattle: {self.observeMessages()}, errorCallbackForAcceptBattle: self.onError)
            }
            let cancelAction = UIAlertAction(title: "No", style: .cancel) {
                UIAlertAction in
                MichVSTransport.declineBattle(token: (UIApplication.shared.delegate as! AppDelegate).token!, battleId: self.battleId,
                        successCallbackForDeclineBattle: {}, errorCallbackForDeclineBattle: self.onError)
            }
            alert.addAction(cancelAction)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        else if battle.status == 1 {
            observeMessages()
        } else if battle.status == 2 {
            self.inputToolbar.contentView.textView.isEditable = false
            self.inputToolbar.isHidden = true
        } else {
            self.inputToolbar.contentView.textView.isEditable = false
            self.inputToolbar.isHidden = true
        }
        finishSendingMessage()
    }
    
    func observeMessages() {
        newMessageRefHandle = messageRef.observe(.childAdded, with: { (snapshot) -> Void in
            if let JSONData = try? JSONSerialization.data(withJSONObject: snapshot.value ?? "{}", options: []) {
                let JSONText = String(data: JSONData, encoding: .ascii)
                if let msg = BattleMessage(JSONString: JSONText!) {
                    msg.id = snapshot.key
                    self.messages.append(JSQMessage(senderId: String(msg.senderId!), displayName: msg.senderDisplayName, text: msg.text))
                    self.collectionView.reloadData()
                } else {
                    print("Error! Could not decode channel data")
                }
            }
        })
    }
    
    // MARK: callbacks
    func onGetBattleSuccess(resp: Battle) {
        self.battle = resp
        loadBattle(battle: self.battle)
    }
    
    func onError(error: DefaultError) {
        let alert = UIAlertController(title: "Alert", message: error.errorString, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: JSQcollectionviewcell delegate
    func messagesCollectionViewCellDidTapMessageBubble(_ cell: JSQMessagesCollectionViewCell!) {
        print("WAT")
    }
    func messagesCollectionViewCellDidTapAvatar(_ cell: JSQMessagesCollectionViewCell!) {}
    func messagesCollectionViewCell(_ cell: JSQMessagesCollectionViewCell!, didPerformAction action: Selector!, withSender sender: Any!) {}
    func messagesCollectionViewCellDidTap(_ cell: JSQMessagesCollectionViewCell!, atPosition position: CGPoint) {}
    
    // MARK: actions
    @IBAction func didVoteForHost(_ sender: Any) {
        self.hostPointCountLabel.text = String(Int(self.hostPointCountLabel.text!)! + 1)
    }
    @IBAction func didVoteForGuest(_ sender: Any) {
        self.guestPointCountLabel.text = String(Int(self.guestPointCountLabel.text!)! + 1)
    }
}

