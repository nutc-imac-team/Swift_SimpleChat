//
//  ConversationsVC.swift
//  FireBase_Chat
//
//  Created by Reaper on 2018/3/26.
//  Copyright © 2018年 Reaper. All rights reserved.
//

import UIKit
import Toaster

class ConversationsVC: UIViewController , UITableViewDelegate , UITableViewDataSource{

    @IBOutlet var conversationsView: ConversationsView!
    var items = [Conversation]()
    var selectedUser: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.backToLoginVC), name: Notification.Name.init("LogOut"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.gotoChat), name: Notification.Name.init("gotoChat"), object: nil)
        
        self.setView()
        self.DownloadData()
        
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoChatVC"{
            let vc = segue.destination as! ChatVC
            vc.currentUser = self.selectedUser
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Methods
    
    func setView(){
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.3043871265, green: 0.5373579988, blue: 1, alpha: 1)
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.navigationItem.title = "Conversations"
        let rightBtnItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "profilePic_m"), style: .done, target: self, action: #selector(self.gotoProfileVC))
        let leftBtnItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "contact"), style: .done, target: self, action: #selector(self.gotoContactsVC))
        self.navigationItem.rightBarButtonItem = rightBtnItem
        self.navigationItem.leftBarButtonItem = leftBtnItem
        
        self.conversationsView.tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        self.conversationsView.tableView.rowHeight = 80
        self.conversationsView.tableView.delegate = self
        self.conversationsView.tableView.dataSource = self
    }
    
    func DownloadData(){
        Conversation.showConversations { (conversations) in
            self.items = conversations
            self.items.sort{ $0.lastMessage.timestamp > $1.lastMessage.timestamp }
            DispatchQueue.main.async {
                self.conversationsView.tableView.reloadData()
            }
        }
    }

    //MARK: - TableView Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ConversationsTVCell
        
        cell.reSetCell()
        cell.profilePic.image = self.items[indexPath.row].user.profilePic
        cell.nameLabel.text = self.items[indexPath.row].user.name
        switch self.items[indexPath.row].lastMessage.type {
        case .text:
            let message = self.items[indexPath.row].lastMessage.content as! String
            cell.lastMessageLabel.text = message
        default:
            cell.lastMessageLabel.text = "Photo"
        }
        let messageDate = Date.init(timeIntervalSince1970: TimeInterval(self.items[indexPath.row].lastMessage.timestamp))
        let dataformatter = DateFormatter.init()
        dataformatter.timeStyle = .short
        let date = dataformatter.string(from: messageDate)
        cell.timeLabel.text = date
        if !self.items[indexPath.row].lastMessage.isRead && self.items[indexPath.row].lastMessage.owner == .sender{
            cell.lastMessageLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.items.count > 0 {
            self.selectedUser = self.items[indexPath.row].user
            self.performSegue(withIdentifier: "gotoChatVC", sender: nil)
        }
    }
    
    
    
    @objc func backToLoginVC(){
        User.logOut { (_) in
            Toast.init(text: "LogOut Suceesfully").show()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func gotoChat(_ notification:Notification){
        if let user = notification.userInfo?["user"] as? User {
            self.selectedUser = user
            self.performSegue(withIdentifier: "gotoChatVC", sender: nil)
        }
    }
    
    @objc func gotoProfileVC(){
        self.performSegue(withIdentifier: "gotoProfileVCId", sender: nil)
    }

    @objc func gotoContactsVC(){
        self.performSegue(withIdentifier: "gotoContactsVCId", sender: nil)

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
