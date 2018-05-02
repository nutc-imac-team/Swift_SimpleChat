//
//  ContactsVC.swift
//  FireBase_Chat
//
//  Created by Reaper on 2018/3/26.
//  Copyright © 2018年 Reaper. All rights reserved.
//

import UIKit
import Firebase

class ContactsVC: UIViewController , UICollectionViewDelegate  , UICollectionViewDataSource {
   
    @IBOutlet var contactsView: ContactsView!
    
    var items = [User]()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.contactsView.collectionView.delegate = self
        self.contactsView.collectionView.dataSource = self
        
        self.DownloadUsers()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Methods
    func DownloadUsers(){
        if let id = Auth.auth().currentUser?.uid {
            User.downloadAllUser(ID: id, completion: { (user) in
                DispatchQueue.main.async {
                    self.items.append(user)
                    self.contactsView.collectionView.reloadData()
                }
            })
        }
    }
    
    //MARK: - CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)as! ContactsCVCell
        cell.profilePic.image = self.items[indexPath.row].profilePic
        cell.nameLabel.text = self.items[indexPath.row].name
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.items.count > 0 {
            let userInfo = ["user":self.items[indexPath.item]]
            self.dismiss(animated: true, completion: nil)
            NotificationCenter.default.post(name: Notification.Name.init("gotoChat"), object: nil, userInfo: userInfo)
        }
    }
    
    //MARK: - Btn Action
    @IBAction func BackToConversationVC(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
