//
//  RegisterView.swift
//  FireBase_Chat
//
//  Created by Reaper on 2018/3/26.
//  Copyright © 2018年 Reaper. All rights reserved.
//

import UIKit

class RegisterView: UIView {

    @IBOutlet weak var informationView: UIView!
    @IBOutlet weak var picBtn: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var backLoginBtn: UIButton!
    @IBOutlet var inputTextFidles: [UITextField]!
    @IBOutlet weak var darkView: UIView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    override func draw(_ rect: CGRect) {
        informationView.layer.cornerRadius = 10
        picBtn.layer.cornerRadius = picBtn.frame.size.width / 2
        picBtn.layer.masksToBounds = true
        registerBtn.layer.cornerRadius = 20
        backLoginBtn.layer.cornerRadius = 20
    }
    
   

}
