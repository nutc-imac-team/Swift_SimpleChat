//
//  ChatVC.swift
//  FireBase_Chat
//
//  Created by Reaper on 2018/3/27.
//  Copyright © 2018年 Reaper. All rights reserved.
//

import UIKit
import Firebase

class ChatVC: UIViewController , UITableViewDelegate , UITableViewDataSource , UIImagePickerControllerDelegate , UINavigationControllerDelegate{

    @IBOutlet var chatView: ChatView!
    
    var currentUser: User?
    var items = [Message]()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setView()
        self.DownloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoShowImageVC"{
            let vc = segue.destination as! ShowImageVC
            vc.image = sender as? UIImage
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Methods
    func setView(){
        self.navigationItem.title = self.currentUser?.name
        self.chatView.tableView.delegate = self
        self.chatView.tableView.dataSource = self
        self.chatView.tableView.estimatedRowHeight = 50
        self.chatView.tableView.transform = CGAffineTransform.init(scaleX: 1, y: -1)
    }
    
    func DownloadData(){
        Message.downloadAllMessages(forUserID: self.currentUser!.id, completion: {(message) in
            self.items.append(message)
            self.items.sort{ $0.timestamp > $1.timestamp }
            DispatchQueue.main.async {
                    self.chatView.tableView.reloadData()
                    self.chatView.tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: false)
            }
        })
        Message.markMessagesRead(forUserID: self.currentUser!.id)
    }
    
    func sendMessage(type: MessageType, content: Any)  {
        let message = Message.init(type: type, content: content, owner: .sender, timestamp: Int(Date().timeIntervalSince1970), isRead: false)
        Message.send(message: message, toID: self.currentUser!.id, completion: {(_) in
        })
    }

    //MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.items[indexPath.row].owner {
        case .receiver:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Receiver", for: indexPath) as! ReceiverCell
            cell.reSetCell()
            switch self.items[indexPath.row].type {
            case .text:
                cell.message.text = self.items[indexPath.row].content as! String
            case .photo:
                if let image = self.items[indexPath.row].image {
                    var newImage = UIImage()
                    if image.size.width > 200 {
                        newImage = image.resizeToSize(size: CGSize.init(width: 200, height: image.size.height * (200/image.size.width)))
                    }
                    cell.messageBackground.image = newImage
                    cell.message.isHidden = true
                } else {
                    self.items[indexPath.row].downloadImage(indexpathRow: indexPath.row, completion: { (state, index) in
                        if state == true {
                            DispatchQueue.main.async {
                                self.chatView.tableView.reloadData()
                            }
                        }
                    })
                }
            }
            cell.contentView.transform = CGAffineTransform.init(scaleX: 1, y: -1)
            return cell
        case .sender:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Sender", for: indexPath) as! SenderCell
            cell.reSetCell()
            switch self.items[indexPath.row].type {
            case .text:
                cell.message.text = self.items[indexPath.row].content as! String
            case .photo:
                if let image = self.items[indexPath.row].image {
                    var newImage = UIImage()
                    if image.size.width > 200 {
                        newImage = image.resizeToSize(size: CGSize.init(width: 200, height: image.size.height * (200/image.size.width)))
                    }
                    cell.messageBackground.image = newImage
                    cell.message.isHidden = true
                } else {
                    self.items[indexPath.row].downloadImage(indexpathRow: indexPath.row, completion: { (state, index) in
                        if state == true {
                            DispatchQueue.main.async {
                                self.chatView.tableView.reloadData()
                            }
                        }
                    })
                }
            }
            cell.contentView.transform = CGAffineTransform.init(scaleX: 1, y: -1)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.items.count > 0 {
            if self.items[indexPath.row].type == .photo {
                self.performSegue(withIdentifier: "gotoShowImageVC", sender: self.items[indexPath.row].image)
            }
        }
    }
    
    //MARK: - UIImagePickerViewController Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            self.sendMessage(type: .photo, content: image)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Btn Action
    @IBAction func selectPhoto(_ sender: Any) {
        
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
    @IBAction func sendMessage(_ sender: Any) {
        let newString = self.chatView.inputTextView.text.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "")
        if newString != ""{
            self.sendMessage(type: .text, content: newString)
            self.chatView.inputTextView.text = ""
        }
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
