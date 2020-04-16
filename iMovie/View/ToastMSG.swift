//
//  ToastMSG.swift
//  iMovie
//
//  Created by Ahmed Ramzy on 1/10/20.
//  Copyright © 2020 Ahmed Ramzy. All rights reserved.
//

import Foundation
import UIKit

class ToastMSG{
    
    static func showToast(message : String , VC : UIViewController) {

        let toastLabel = UILabel(frame: CGRect(x: VC.view.frame.size.width/2 - 75, y: VC.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        VC.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
