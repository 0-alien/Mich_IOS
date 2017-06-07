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

class VSJSQViewController: JSQMessagesViewController {

    var channelRef: FIRDatabaseReference?
    var battle: Battle!
    var battleId: Int!
    var messages = [JSQMessage]()
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    private lazy var messageRef: FIRDatabaseReference = self.channelRef!.child("messages")
    private var newMessageRefHandle: FIRDatabaseHandle?
    var vsId: Int!
    
    var channel: Channel? {
        didSet {
            title = channel?.name
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        if battle == nil {
            MichVSTransport.getBattle(token: (UIApplication.shared.delegate as! AppDelegate).token!, id: self.battleId, successCallbackForGetBattle: onGetBattleSuccess, errorCallbackForGetBattle: onError)
        }
        else {
            loadBattle(battle: self.battle)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        /*let itemRef = messageRef.childByAutoId() // 1*/
        let mes = JSQMessage(senderId: self.senderId, displayName: self.senderDisplayName, text: text)
        messages.append(mes!)
        //finishSendingMessage()
        /*
        itemRef.setValue(messageItem) // 3
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound() // 4
        */
        finishSendingMessage() // 5
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        
    }
    
    func loadBattle(battle: Battle) {
        self.senderId = String(battle.host!.id!)
        self.senderDisplayName = battle.host?.username
        if battle.status == 0 {
            let alert = UIAlertController(title: "Alert", message: "Accept battle with" + (battle.host?.username)!, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Yes", style: .default) {
                UIAlertAction in
                NSLog("OK Pressed")
            }
            let cancelAction = UIAlertAction(title: "No", style: .cancel) {
                UIAlertAction in
                NSLog("Cancel Pressed")
            }
            alert.addAction(okAction)
            alert.addAction(cancelAction)
        }
        finishSendingMessage()
    }
    
    func okAction() {
        
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

}

