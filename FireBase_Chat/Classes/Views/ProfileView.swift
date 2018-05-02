//
//  ProfileView.swift
//  FireBase_Chat
//
//  Created by Reaper on 2018/3/26.
//  Copyright © 2018年 Reaper. All rights reserved.
//

import UIKit

class ProfileView: UIView {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var informationView: UIView!
    @IBOutlet weak var profilePicBtn: UIButton!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileEmailLabel: UILabel!
    @IBOutlet weak var logOutBtn: UIButton!
    
    override func draw(_ rect: CGRect) {
        self.informationView.layer.cornerRadius = 10
        self.logOutBtn.layer.cornerRadius = 20
        self.profilePicBtn.layer.cornerRadius = self.profilePicBtn.frame.size.width/2
        self.profilePicBtn.layer.masksToBounds = true
    }
    

}
