//
//  User.swift
//  FireBase_Chat
//
//  Created by Reaper on 2018/3/28.
//  Copyright © 2018年 Reaper. All rights reserved.
//

import UIKit
import Firebase

class User {

    let name: String
    let email: String
    let id: String
    var profilePic: UIImage
    
    init(name:String , email:String , id:String , profilePic:UIImage) {
        self.name = name
        self.email = email
        self.id = id
        self.profilePic = profilePic
    }
    
    class func register(name:String , email:String , password:String , profilePic:UIImage , completion:@escaping (Bool)->()){
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error == nil {
                let imageData = UIImageJPEGRepresentation(profilePic, 0.1)
                let storage = Storage.storage().reference().child("usersProfilePics").child((user?.uid)!)
                storage.putData(imageData!, metadata: nil, completion: { (metaData, error) in
                    if error == nil {
                        let path = metaData?.downloadURL()?.absoluteString
                        let values = ["name": name, "email": email, "profilePicLink": path!]
                        Database.database().reference().child("users").child((user?.uid)!).child("credentials").updateChildValues(values, withCompletionBlock: { (error, _) in
                            if error == nil {
                                let userInfo = ["email" : email, "password" : password]
                                UserDefaults.standard.set(userInfo, forKey: "userInfo")
                                completion(true)
                            }
                        })
                    }
                })
                
            }else{
                completion(false)
            }
        }
        
    }
    
    class func login(email:String , password:String , completion:@escaping (Bool)->()){
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error == nil {
                let userInfo = ["email": email, "password": password]
                UserDefaults.standard.set(userInfo, forKey: "userInfo")
                completion(true)
            }else{
                completion(false)
            }
        }
    }
    
    class func logOut(completion:(Bool)->()){
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: "userInfo")
            completion(true)
        } catch _ {
            completion(false)
        }
    }
    
    class func info(userID:String , completion:@escaping (User)->()){
        Database.database().reference().child("users").child(userID).child("credentials").observeSingleEvent(of: .value) { (snapshot) in
            if let data = snapshot.value as? [String:String]{
                let name = data["name"]!
                let email = data["email"]!
                let link = URL.init(string: data["profilePicLink"]!)
                URLSession.shared.dataTask(with: link!, completionHandler: { (data, response, error) in
                    if error == nil {
                        let profilePic = UIImage.init(data: data!)
                        let user = User.init(name: name, email: email, id: userID, profilePic: profilePic!)
                        completion(user)
                    }
                }).resume()
            }
        }
    }
    
    class func updateInfo(userID:String , name:String,email:String, newPic:UIImage , completion:@escaping (Bool)->()){
       
        let imageData = UIImageJPEGRepresentation(newPic, 0.1)!
        let storage = Storage.storage().reference().child("usersProfilePics").child(userID)
        storage.putData(imageData, metadata: nil) { (metaData, error) in
            if error == nil{
                let path = metaData?.downloadURL()?.absoluteString
                let values:[AnyHashable:Any] = ["name": name , "email": email, "profilePicLink": path!]
              Database.database().reference().child("users").child(userID).child("credentials").updateChildValues(values, withCompletionBlock: { (error, _) in
                    if error == nil {
                        completion(true)
                    }
                })
            }
        }
    }
    
    class func downloadAllUser(ID:String , completion:@escaping (User)->()){
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            let id = snapshot.key
            let data = snapshot.value as! [String: Any]
            let credentials = data["credentials"] as! [String: String]
            if id != ID {
                let name = credentials["name"]!
                let email = credentials["email"]!
                let link = URL.init(string: credentials["profilePicLink"]!)
                URLSession.shared.dataTask(with: link!, completionHandler: { (data, response, error) in
                    if error == nil {
                        let profilePic = UIImage.init(data: data!)
                        let user = User.init(name: name, email: email, id: id, profilePic: profilePic!)
                        completion(user)
                        
                    }
                }).resume()
            }
        })
    }
    
}
