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
import Photos

class VSJSQViewController: JSQMessagesViewController, JSQMessagesCollectionViewCellDelegate, Finishable  {

    lazy var storageRef: FIRStorageReference = FIRStorage.storage().reference(forURL: "gs://mich-ios.appspot.com")
    private let imageURLNotSetKey = "NOTSET"
    private var photoMessageMap = [String: JSQPhotoMediaItem]()
    private var updatedMessageRefHandle: FIRDatabaseHandle?
    
    var channelRef: FIRDatabaseReference?
    var battle: Battle!
    var battleId: Int!
    var messages = [JSQMessage]()
    var messageDelegate: MessageDelegate!
    
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    
    private var messageRef: FIRDatabaseReference!
    private var newMessageRefHandle: FIRDatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        channelRef = FIRDatabase.database().reference() //connect to database
        self.automaticallyScrollsToMostRecentMessage = true
        self.collectionView.collectionViewLayout.messageBubbleFont = UIFont(name: "Helvetica", size: UIFont.systemFontSize)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.collectionView.contentSize.height > self.collectionView.frame.height {
            self.collectionView.setContentOffset(
                CGPoint(x: 0, y: self.collectionView.contentSize.height
                    - self.collectionView.frame.height + self.inputToolbar.bounds.height),
                animated: animated)
        }
        self.messages.removeAll()
        self.collectionView.reloadData()
        if self.battle == nil {
            MichVSTransport.getBattle(token: (UIApplication.shared.delegate as! AppDelegate).token!, battleId: self.battleId, successCallbackForGetBattle: onGetBattleSuccess, errorCallbackForGetBattle: onError)
        } else {
            self.loadBattle(battle: self.battle)
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.removeObservers()
        self.messages.removeAll()
        self.collectionView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - sending media
    func sendPhotoMessage() -> String? {
        let itemRef = messageRef.childByAutoId()
        let mes = BattleMessage(id: itemRef.key, senderId: Int(self.senderId)!, senderDisplayName: self.senderDisplayName, text: self.imageURLNotSetKey)
        mes.isMedia = true
        itemRef.setValue(mes.toJSON())
        finishSendingMessage()
        return itemRef.key
    }
    
    func setImageURL(_ url: String, forPhotoMessageWithKey key: String) {
        let itemRef = messageRef.child(key)
        itemRef.updateChildValues(["text": url])
    }
    
    private func addPhotoMessage(withId id: String, key: String, mediaItem: JSQPhotoMediaItem) {
        if let message = JSQMessage(senderId: id, displayName: "", media: mediaItem) {
            messages.append(message)
            
            if (mediaItem.image == nil) {
                photoMessageMap[key] = mediaItem
            }
            
            collectionView.reloadData()
        }
    }
    
    override func didPressAccessoryButton(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
            picker.sourceType = UIImagePickerControllerSourceType.camera
        } else {
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        }
        
        present(picker, animated: true, completion:nil)
    }
    
    private func fetchImageDataAtURL(_ photoURL: String, forMediaItem mediaItem: JSQPhotoMediaItem, clearsPhotoMessageMapOnSuccessForKey key: String?) {
        // 1
        let storageRef = FIRStorage.storage().reference(forURL: photoURL)
        
        // 2
        storageRef.data(withMaxSize: INT64_MAX){ (data, error) in
            if let error = error {
                print("Error downloading image data: \(error)")
                return
            }
            
            // 3
            storageRef.metadata(completion: { (metadata, metadataErr) in
                if let error = metadataErr {
                    print("Error downloading metadata: \(error)")
                    return
                }
            
                
                mediaItem.image = UIImage.init(data: data!)
                
                self.collectionView.reloadData()
                
                // 5
                guard key != nil else {
                    return
                }
                self.photoMessageMap.removeValue(forKey: key!)
            })
        }
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
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleRed())
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
        //JSQSystemSoundPlayer.jsq_playMessageSentSound()
        finishSendingMessage()
    }

    
    
    func loadBattle(battle: Battle) {
        self.battle = battle
        if !battle.myBattle! {
            self.inputToolbar.contentView.textView.isEditable = false
            self.inputToolbar.isHidden = true
            self.senderId = String((self.battle.host?.id)! + 0)
            self.senderDisplayName = self.battle.host?.username
            // self.inputToolbar.removeFromSuperview() warning
        }
        if battle.status == 0 && battle.iAmGuest! {
            let alert = UIAlertController(title: "Alert", message: "Accept battle with " + (battle.host?.username)!, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Yes", style: .default) {
                UIAlertAction in
                MichVSTransport.acceptBattle(token: (UIApplication.shared.delegate as! AppDelegate).token!, battleId: self.battleId,
                    successCallbackForAcceptBattle: {self.battle.status = 1
                                                    self.observeMessages()
                        self.messageDelegate.startObserving(status: 1)},
                                                    errorCallbackForAcceptBattle: self.onError)
            }
            let cancelAction = UIAlertAction(title: "No", style: .cancel) {
                UIAlertAction in
                MichVSTransport.declineBattle(token: (UIApplication.shared.delegate as! AppDelegate).token!, battleId: self.battleId,
                    successCallbackForDeclineBattle: {self.messageDelegate.didCancel()}, errorCallbackForDeclineBattle: self.onError)
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
            observeMessages()
        }
    }
    
    func observeMessages() {
        messageRef = self.channelRef!.child(String(self.battleId)).child("messages")

        newMessageRefHandle = messageRef.observe(.childAdded, with: { (snapshot) -> Void in
            if let JSONData = try? JSONSerialization.data(withJSONObject: snapshot.value ?? "{}", options: []) {
                let JSONText = String(data: JSONData, encoding: .utf8)
                if let msg = BattleMessage(JSONString: JSONText!) {
                    if msg.isMedia {
                        if let mediaItem = JSQPhotoMediaItem(maskAsOutgoing: msg.senderId == Int(self.senderId)) {
                            self.addPhotoMessage(withId: String(msg.senderId!), key: snapshot.key, mediaItem: mediaItem)
                            if (msg.text?.hasPrefix("gs://"))! {
                                self.fetchImageDataAtURL(msg.text!, forMediaItem: mediaItem, clearsPhotoMessageMapOnSuccessForKey: nil)
                            }
                        }
                    }
                    else {
                        msg.id = snapshot.key
                        self.messages.append(JSQMessage(senderId: String(msg.senderId!), displayName: msg.senderDisplayName, text: msg.text))
                        self.collectionView.reloadData()
                        self.scrollToBottom(animated: true)
                    }
                } else {
                    print("Error! Could not decode channel data")
                }
            }
        })
        updatedMessageRefHandle = messageRef.observe(.childChanged, with: { (snapshot) -> Void in
            print("dawdawdwadaw")
            if let JSONData = try? JSONSerialization.data(withJSONObject: snapshot.value ?? "{}", options: []) {
                print("------")
                let JSONText = String(data: JSONData, encoding: .utf8)
                if let msg = BattleMessage(JSONString: JSONText!) {
                    msg.id = snapshot.key
                    print("DAWDAW")
                    if let mediaItem = self.photoMessageMap[msg.id!] { // 3
                        print(msg.text)
                        self.fetchImageDataAtURL(msg.text!, forMediaItem: mediaItem, clearsPhotoMessageMapOnSuccessForKey: msg.id) // 4
                    }
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
        if let rr = updatedMessageRefHandle {
            messageRef.removeObserver(withHandle: rr)
        }
    }

    // MARK: - finishable
    func finish() {
        self.view.endEditing(true)
        self.inputToolbar.contentView.textView.isEditable = false
        self.inputToolbar.isHidden = true
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
    func messagesCollectionViewCellDidTapMessageBubble(_ cell: JSQMessagesCollectionViewCell!) {}
    func messagesCollectionViewCellDidTapAvatar(_ cell: JSQMessagesCollectionViewCell!) {}
    func messagesCollectionViewCell(_ cell: JSQMessagesCollectionViewCell!, didPerformAction action: Selector!, withSender sender: Any!) {}
    func messagesCollectionViewCellDidTap(_ cell: JSQMessagesCollectionViewCell!, atPosition position: CGPoint) {}
}

extension VSJSQViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion:nil)
        
        // 1
        if let photoReferenceUrl = info[UIImagePickerControllerReferenceURL] as? URL {
            // Handle picking a Photo from the Photo Library
            // 2
             print("____________________")
            let assets = PHAsset.fetchAssets(withALAssetURLs: [photoReferenceUrl], options: nil)
            let asset = assets.firstObject
            print("shemovidaaaa")
            // 3
            if let key = sendPhotoMessage() {
                
                // 4
                asset?.requestContentEditingInput(with: nil, completionHandler: { (contentEditingInput, info) in
                    let imageFileURL = contentEditingInput?.fullSizeImageURL
                    
                    // 5
                    let path = "/\(Int(Date.timeIntervalSinceReferenceDate * 1000))/\(photoReferenceUrl.lastPathComponent)"
                    
                    // 6
                    self.storageRef.child(path).putFile(imageFileURL!, metadata: nil) { (metadata, error) in
                        if let error = error {
                            print("Error uploading photo: \(error.localizedDescription)")
                            return
                        }
                        // 7
                        self.setImageURL(self.storageRef.child((metadata?.path)!).description, forPhotoMessageWithKey: key)
                        print("1111132131232131")
                        self.collectionView.reloadData()
                    }
                })
            }
        } else {
            // 1
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            // 2
            if let key = sendPhotoMessage() {
                // 3
                let imageData = UIImageJPEGRepresentation(image, 1.0)
                // 4
                let imagePath = "/\(Int(Date.timeIntervalSinceReferenceDate * 1000)).jpg"
                // 5
                let metadata = FIRStorageMetadata()
                metadata.contentType = "image/jpeg"
                // 6
                storageRef.child(imagePath).put(imageData!, metadata: metadata) { (metadata, error) in
                    if let error = error {
                        print("Error uploading photo: \(error)")
                        return
                    }
                    // 7
                    self.setImageURL(self.storageRef.child((metadata?.path)!).description, forPhotoMessageWithKey: key)
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion:nil)
    }
    
}

