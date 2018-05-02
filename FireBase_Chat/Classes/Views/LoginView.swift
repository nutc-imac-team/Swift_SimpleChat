//
//  LoginView.swift
//  FireBase_Chat
//
//  Created by Reaper on 2018/3/26.
//  Copyright © 2018年 Reaper. All rights reserved.
//

import UIKit

class LoginView: UIView {

    @IBOutlet weak var informationView: UIView!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var signinBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var darkView: UIView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet var inputTextField: [UITextField]!
    
    
    override func draw(_ rect: CGRect) {
        
    informationView.layer.cornerRadius = 10
        signinBtn.layer.cornerRadius = 20
        registerBtn.layer.cornerRadius = 20
        
    }
}
