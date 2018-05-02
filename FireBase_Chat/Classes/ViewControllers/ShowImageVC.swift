//
//  ShowImageVC.swift
//  FireBase_Chat
//
//  Created by Reaper on 2018/4/11.
//  Copyright © 2018年 Reaper. All rights reserved.
//

import UIKit

class ShowImageVC: UIViewController {
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var showImageView: UIImageView!
    
    var image : UIImage?
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if let image = self.image{
            self.showImageView.image = image
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Tap Action
    @IBAction func backToChatVC(_ sender: Any) {
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
