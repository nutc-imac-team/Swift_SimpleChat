//
//  ProfileVC.swift
//  FireBase_Chat
//
//  Created by Reaper on 2018/3/26.
//  Copyright © 2018年 Reaper. All rights reserved.
//

import UIKit
import Firebase
import Toaster

class ProfileVC: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate {

    @IBOutlet var profileView: ProfileView!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.downloadUserInfo()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Methods
    func downloadUserInfo() {
        if let id = Auth.auth().currentUser?.uid {
            User.info(userID: id, completion: {(user) in
                DispatchQueue.main.async {
                    self.profileView.profileNameLabel.text = user.name
                    self.profileView.profileEmailLabel.text = user.email
                    self.profileView.profilePicBtn.setImage(user.profilePic, for: .normal)
                }
            })
        }
    }
    
    //MARK: - UIImagePickerView Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            if let id = Auth.auth().currentUser?.uid{
                User.updateInfo(userID: id, name: self.profileView.profileNameLabel.text!, email: self.profileView.profileEmailLabel.text!, newPic: image, completion: { (success) in
                    if success{
                        self.profileView.profilePicBtn.setImage(image, for: .normal)
                    }else{
                        Toast.init(text: "Oops, something has gone wrong.").show()
                    }
                })
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - BtnAction
    @IBAction func backToConversationVC(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backToLoginVC(_ sender: Any) {
        self.dismiss(animated: false) {
            NotificationCenter.default.post(name: Notification.Name.init("LogOut"), object: nil)
        }
    }
    @IBAction func changePic(_ sender: Any) {
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
