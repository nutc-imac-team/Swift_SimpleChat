//
//  Extension.swift
//  FireBase_Chat
//
//  Created by Reaper on 2018/4/11.
//  Copyright © 2018年 Reaper. All rights reserved.
//

import UIKit

extension UIImage {
    func resizeToSize(size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        self.draw(in: CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

