//
//  RegisterVC.swift
//  FireBase_Chat
//
//  Created by Reaper on 2018/3/26.
//  Copyright © 2018年 Reaper. All rights reserved.
//

import UIKit
import Toaster

class RegisterVC: UIViewController , UITextFieldDelegate , UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    
    @IBOutlet var registerView: RegisterView!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Btn Action
    @IBAction func register(_ sender: Any) {
        
        for textField in self.registerView.inputTextFidles{
            textField.resignFirstResponder()
        }
        self.Loading(true)
        User.register(name: registerView.nameTextField.text!, email: registerView.emailTextField.text!, password: registerView.passwordTextField.text!, profilePic: (registerView.picBtn.imageView?.image)!) { (success) in
            
            for textField in self.registerView.inputTextFidles{
                textField.text = ""
            }
            self.Loading(false)
           
            if success{
                Toast.init(text: "Register suceesfully").show()
                self.dismiss(animated: true, completion: nil)
            }else{
                Toast.init(text: "Register Failed").show()
            }
            
        }
    }
    
    @IBAction func selectImage(_ sender: Any) {
        
        let actionSheet = UIAlertController.init(title: "Select Photo", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction.init(title: "From Camera", style: .default) { (_) in
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .camera
            self.present(picker, animated: true, completion: nil)
        }
        let albumAction = UIAlertAction.init(title: "From Album", style: .default) { (_) in
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: nil)        }
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(albumAction)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    @IBAction func BackToLoginVC(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Methods
    func Loading(_ state: Bool){
        if state{
            self.registerView.darkView.isHidden = false
            self.registerView.activityView.startAnimating()
            UIView.animate(withDuration: 0.2, animations: {
                self.registerView.darkView.alpha = 0.5
            })
        }else{
            UIView.animate(withDuration: 0.2, animations: {
                self.registerView.darkView.alpha = 0
            }, completion: { (_) in
                self.registerView.activityView.stopAnimating()
                self.registerView.darkView.isHidden = true
            })
        }
    }
    
    
    //MARK: - textField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage]as? UIImage{
            self.registerView.picBtn.setImage(image, for: .normal)
        }
        picker.dismiss(animated: true, completion: nil)
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
