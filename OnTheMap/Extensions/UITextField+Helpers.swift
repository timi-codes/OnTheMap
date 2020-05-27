//
//  UITextField+Helper.swift
//  OnTheMap
//
//  Created by Timi Tejumola on 27/05/2020.
//  Copyright © 2020 Timi Tejumola. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    func setLeftIcon(_ imageName: String){
        
        leftViewMode = .always
        let imageView = UIImageView(frame: CGRect(x: 5, y: 5, width: 20, height: 20))
        imageView.image = UIImage(systemName: imageName)
        
        let iconContainerView: UIView = UIView(frame:
        CGRect(x: 10, y: 0, width: 30, height: 30))
        
        iconContainerView.addSubview(imageView)

        imageView.tintColor = UIColor.white
        leftView = iconContainerView
    }
}


