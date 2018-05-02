//
//  Cells.swift
//  FireBase_Chat
//
//  Created by Reaper on 2018/4/9.
//  Copyright © 2018年 Reaper. All rights reserved.
//

import UIKit

class ConversationsTVCell: UITableViewCell {

    @IBOutlet var profilePic: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var lastMessageLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.profilePic.layer.cornerRadius = profilePic.frame.size.width / 2
        self.profilePic.layer.masksToBounds = true
    }

    func reSetCell(){
        self.lastMessageLabel.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }
    
}

class SenderCell: UITableViewCell {
    
    @IBOutlet var messageBackground: UIImageView!
    @IBOutlet var message: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.message.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5)
        self.messageBackground.layer.cornerRadius = 10
        self.messageBackground.clipsToBounds = true
    }
    func reSetCell(){
        self.message.text = nil
        self.message.isHidden = false
        self.messageBackground.image = nil
    }
}

class ReceiverCell: UITableViewCell {
    @IBOutlet var messageBackground: UIImageView!
    @IBOutlet var message: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.message.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5)
        self.messageBackground.layer.cornerRadius = 10
        self.messageBackground.clipsToBounds = true
    }
    func reSetCell(){
        self.message.text = nil
        self.message.isHidden = false
        self.messageBackground.image = nil
    }
}

class ContactsCVCell: UICollectionViewCell {
    
    @IBOutlet var profilePic: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    
    override func awakeFromNib() {
        self.profilePic.layer.cornerRadius = self.profilePic.frame.size.width / 2
        self.profilePic.layer.masksToBounds = true
    }
    
}
