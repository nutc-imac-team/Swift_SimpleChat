//
//  Conversation.swift
//  FireBase_Chat
//
//  Created by Reaper on 2018/3/30.
//  Copyright © 2018年 Reaper. All rights reserved.
//

import UIKit
import Firebase
import Foundation

class Conversation {

    let user: User
    var lastMessage: Message
    
    init(user: User, lastMessage: Message) {
        self.user = user
        self.lastMessage = lastMessage
    }
    
    //MARK: Methods
    class func showConversations(completion: @escaping ([Conversation]) -> Swift.Void) {
        if let currentUserID = Auth.auth().currentUser?.uid {
            var conversations = [Conversation]()
            Database.database().reference().child("users").child(currentUserID).child("conversations").observe(.childAdded, with: { (snapshot) in
                if snapshot.exists() {
                    let fromID = snapshot.key
                    let values = snapshot.value as! [String: String]
                    let location = values["location"]!
                    User.info(userID: fromID, completion: { (user) in
                        let emptyMessage = Message.init(type: .text, content: "loading", owner: .sender, timestamp: 0, isRead: true)
                        let conversation = Conversation.init(user: user, lastMessage: emptyMessage)
                        conversations.append(conversation)
                        conversation.lastMessage.downloadLastMessage(forLocation: location, completion: { (_) in
                            completion(conversations)
                        })
                    })
                }
            })
        }
    }
    
}
