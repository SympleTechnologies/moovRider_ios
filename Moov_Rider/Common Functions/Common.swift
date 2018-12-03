//
//  Common.swift
//  Moov-Driver
//
//  Created by Srishti Innovative on 10/07/18.
//  Copyright © 2018 Srishti Innovative. All rights reserved.
//

import Foundation
import UIKit

//let kScreenWidth    = UIScreen.main.bounds.width
//let kScreenHeight   = UIScreen.main.bounds.height
let kStoryBoard     = UIStoryboard.init(name: "Main", bundle: nil)


extension UIView {
    
    public func setCornerRadius(withRadius radius: CGFloat, andCorners corners: CACornerMask) {
        
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        if #available(iOS 11.0, *) {
            self.layer.maskedCorners = corners
        } else {
            // Fallback on earlier versions
        }
    }
    
   public func addBorder(toEdges edges: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        func addBorder(toEdge edges: UIRectEdge, color: UIColor, thickness: CGFloat) {
            let border = CALayer()
            border.backgroundColor = color.cgColor
            
            switch edges {
            case .top:
                border.frame = CGRect(x: 0, y: 0, width: frame.width, height: thickness)
            case .bottom:
                border.frame = CGRect(x: 0, y: frame.height - thickness, width: frame.width, height: thickness)
            case .left:
                border.frame = CGRect(x: 0, y: 0, width: thickness, height: frame.height)
            case .right:
                border.frame = CGRect(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
            default:
                break
            }
            layer.addSublayer(border)
        }
        
        if edges.contains(.top) || edges.contains(.all) {
            addBorder(toEdge: .top, color: color, thickness: thickness)
        }
        if edges.contains(.bottom) || edges.contains(.all) {
            addBorder(toEdge: .bottom, color: color, thickness: thickness)
        }
        if edges.contains(.left) || edges.contains(.all) {
            addBorder(toEdge: .left, color: color, thickness: thickness)
        }
        if edges.contains(.right) || edges.contains(.all) {
            addBorder(toEdge: .right, color: color, thickness: thickness)
        }
    }
}

extension UITextField {
    
    func setPadding(left: CGFloat? = nil, right: CGFloat? = nil, withIcons iconLeft: UIImage? = nil, iconRight: UIImage? = nil) {
        if let left = left {
            let paddingView = UIButton(frame: CGRect(x: 0, y: 0, width: left, height: self.frame.size.height))
            if let leftImage = iconLeft {
                paddingView.setImage(leftImage, for: .normal)
            }
            self.leftView = paddingView
            self.leftViewMode = .always
        }
        
        if let right = right {
            let paddingView = UIButton(frame: CGRect(x: 0, y: 0, width: right, height: self.frame.size.height))
            paddingView.contentMode = .scaleAspectFill
            if let rightImage = iconRight {
                paddingView.setImage(rightImage, for: .normal)
            }
            self.rightView = paddingView
            self.rightViewMode = .always
        }
    }
}
