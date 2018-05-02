//
//  LoginVC.swift
//  FireBase_Chat
//
//  Created by Reaper on 2018/3/26.
//  Copyright © 2018年 Reaper. All rights reserved.
//

import UIKit
import Toaster
import Firebase

class LoginVC: UIViewController {
    
    @IBOutlet var loginView: LoginView!
    
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        if let userInformation = UserDefaults.standard.dictionary(forKey: "userInfo") {
            let email = userInformation["email"] as! String
            let password = userInformation["password"] as! String
            self.Loading(true)
            self.login(email: email, password: password)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Methods
    func Loading(_ state: Bool){
        if state{
            self.loginView.darkView.isHidden = false
            self.loginView.activityView.startAnimating()
            UIView.animate(withDuration: 0.2, animations: {
                self.loginView.darkView.alpha = 0.5
            })
        }else{
            UIView.animate(withDuration: 0.2, animations: {
                self.loginView.darkView.alpha = 0
            }, completion: { (_) in
                self.loginView.activityView.stopAnimating()
                self.loginView.darkView.isHidden = true
            })
        }
    }
    
    func login(email:String , password:String){
        User.login(email: email, password: password) { (success) in
            
            for textField in self.loginView.inputTextField{
                textField.text = ""
            }
            self.Loading(false)
            
            if success{
                Toast.init(text: "Login Suceesfully").show()
                self.performSegue(withIdentifier: "gotoConversationsVCId", sender: nil)
            }else{
                Toast.init(text: "Login Failed").show()
            }
        }
    }
    
    //MARK: - Btn Action
    @IBAction func gotoRegisterVC(_ sender: Any) {
        self.performSegue(withIdentifier: "gotoRegisterVCId", sender: nil)
    }
    
    @IBAction func signInAction(_ sender: Any) {

        for textField in self.loginView.inputTextField {
            textField.resignFirstResponder()
        }
        self.Loading(true)
        self.login(email: self.loginView.emailTextfield.text!, password: self.loginView.passwordTextfield.text!)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
