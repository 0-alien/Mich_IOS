//
//  ChatViewController.swift
//  Mich
//
//  Created by Gigi Pataraia on 10/11/17.
//  Copyright © 2017 Lemon. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Firebase

class ChatViewController: JSQMessagesViewController, JSQMessagesCollectionViewCellDelegate {

    
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    
    var chat: Chat! = nil
    var userId: Int!
    var messages = [JSQMessage]()
    
    private var messageRef: FIRDatabaseReference!
    var channelRef: FIRDatabaseReference?
    private var newMessageRefHandle: FIRDatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        channelRef = FIRDatabase.database().reference() //connect to database
        
        
        MichMessagesTransport.getChat(token: (UIApplication.shared.delegate as! AppDelegate).token!, userId: self.userId, successCallbackGetChat: onGetChatSuccess, errorCallbackForGetChat: onError)
        
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
        let msg = ChatMessage(id: itemRef.key, senderId: Int(self.senderId)!, senderDisplayName: self.senderDisplayName, text: text)
        itemRef.setValue(msg.toJSON())
        finishSendingMessage()
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        
    }
    
    // MARK: JSQcollectionviewcell delegate
    func messagesCollectionViewCellDidTapMessageBubble(_ cell: JSQMessagesCollectionViewCell!) {}
    func messagesCollectionViewCellDidTapAvatar(_ cell: JSQMessagesCollectionViewCell!) {}
    func messagesCollectionViewCell(_ cell: JSQMessagesCollectionViewCell!, didPerformAction action: Selector!, withSender sender: Any!) {}
    func messagesCollectionViewCellDidTap(_ cell: JSQMessagesCollectionViewCell!, atPosition position: CGPoint) {}
    
    // MARK: class methods
    func observeMessages() {
        messageRef = self.channelRef!.child("chat").child(String(self.chat.id! + 0)).child("messages")
        newMessageRefHandle = messageRef.observe(.childAdded, with: { (snapshot) -> Void in
            if let JSONData = try? JSONSerialization.data(withJSONObject: snapshot.value ?? "{}", options: []) {
                let JSONText = String(data: JSONData, encoding: .ascii)
                if let msg = ChatMessage(JSONString: JSONText!) {
                    msg.id = snapshot.key
                    self.messages.append(JSQMessage(senderId: String(msg.senderId!), displayName: msg.senderDisplayName, text: msg.text))
                    self.collectionView.reloadData()
                    self.scrollToBottom(animated: true)
                } else {
                    print("Error! Could not decode channel data")
                }
            }
        })
    }
    
    func removeObservers() {
        if let rr = newMessageRefHandle {
            messageRef.removeObserver(withHandle: rr)
        }
    }
    
    // MARK: callbacks
    func onGetChatSuccess(chat: Chat) {
        self.chat = chat
        self.observeMessages()
    }
    
    func onError(error: DefaultError) {
        let alert = UIAlertController(title: "Alert", message: error.errorString, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
