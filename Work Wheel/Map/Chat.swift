//
//  ViewController.swift
//  ChatUI
//
//  Created by Wilson Balderrama on 1/2/17.
//  Copyright © 2017 Wilson Balderrama. All rights reserved.
//
import UIKit
import Firebase
import FirebaseFirestore

import JSQMessagesViewController

struct User {
    let id: String
    let name: String
}

class ViewController: JSQMessagesViewController {
    let user1 = User(id: "1", name: (Auth.auth().currentUser?.email)!)
    var db = Firestore.firestore()
    let user2 = User(id: "2", name: "Worker" )
    
    
    var currentUser: User {
        return user1
    }
    
    // all messages of users1, users2
    var messages = [JSQMessage]()
}

extension ViewController {
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        let date = Date()
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let year = calendar.component(.year, from: date)
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        let second = calendar.component(.second, from: date)
        let a = "\(month) \(day) \(year) \(hour) \(minute) \(second)"
        let userUID = Auth.auth().currentUser?.uid
        
        let db = Firestore.firestore()
        db.collection("Work").document(userUID!).collection("Chat").document(userUID!).getDocument { (document, error) in
            if(document?.exists==false) {
                db.collection("Work").document(userUID!).collection("Chat").document(userUID!).setData([
                    a : text
                    ])
            }
            else {
                var stuff = Dictionary<String,Any>()
                stuff = (document?.data())!
                stuff[a] = text
                db.collection("Work").document(userUID!).collection("Chat").document(userUID!).setData(
                    stuff
                    )
            }
        }

        let message = JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text)
        
        messages.append(message!)
        
        finishSendingMessage()
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        let message = messages[indexPath.row]
        let messageUsername = message.senderDisplayName
        
        return NSAttributedString(string: messageUsername!)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
        return 15
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        
        let message = messages[indexPath.row]
        
        if currentUser.id == message.senderId {
            return bubbleFactory?.outgoingMessagesBubbleImage(with: .green)
        } else {
            return bubbleFactory?.incomingMessagesBubbleImage(with: .blue)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.row]
    }
}

extension ViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tell JSQMessagesViewController
        // who is the current user
        self.senderId = currentUser.id
        self.senderDisplayName = currentUser.name
        
        
        self.messages = getMessages()
    }
}

extension ViewController {
    func getMessages() -> [JSQMessage] {
        
        var messages = [JSQMessage]()
        var messageArray:[JSQMessage] = [JSQMessage]()
        let email = Auth.auth().currentUser?.email
        let userUID = Auth.auth().currentUser?.uid
        let db = Firestore.firestore()
        db.collection("Work").document(userUID!).collection("Chat").document(userUID!).getDocument { (document, error) in
            if(document!.exists) {
                for i in (document?.data()!.keys)! {
                    var message = JSQMessage(senderId: "1", displayName: email, text: document?.data()![i] as? String)
                    messageArray.append(message!)
                    print("MESSAGE IS: ", message!)
                    messages.append(message!)
                }
            }
            else {
                print("DOCUMENT DOES NOT EXIST")
            }
        }
        for i in messageArray {
            messages.append(i)
        }
//        let message1 = JSQMessage(senderId: "1", displayName: "Steve", text: "Hey Tim how are you?")
//        let message2 = JSQMessage(senderId: "2", displayName: "Tim", text: "Fine thanks, and you?")
        
       // messages.append(message1!)
        //messages.append(message2!)
        
        return messages
    }
}
