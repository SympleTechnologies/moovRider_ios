//
//  RoundedView.swift
//  Moov_Rider
//
//  Created by Henry Chukwu on 12/5/18.
//  Copyright © 2018 Visakh. All rights reserved.
//

import UIKit

@IBDesignable
class CardView: UIView {

    @IBInspectable var cornerradius: CGFloat = 25
    @IBInspectable var shadowOffSetWidth: CGFloat = 0
    @IBInspectable var shadowOffSetHeight: CGFloat = 0
    @IBInspectable var shadowcolor: UIColor = UIColor.black
    @IBInspectable var shadowOpacity: CGFloat = 0.2

    override func layoutSubviews() {

        layer.cornerRadius = cornerradius
        layer.shadowColor = shadowcolor.cgColor
        layer.shadowOffset = CGSize(width: shadowOffSetWidth, height: shadowOffSetHeight)

        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerradius)
        layer.shadowPath = shadowPath.cgPath
        layer.shadowOpacity = Float(shadowOpacity)

    }

}
