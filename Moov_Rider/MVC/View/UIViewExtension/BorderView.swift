//
//  BorderView.swift
//  Moov_Rider
//
//  Created by Henry Chukwu on 12/5/18.
//  Copyright © 2018 Visakh. All rights reserved.
//

import UIKit

class BorderView : UIView {

    var borderColor = UIColor(red:0.78, green:0.78, blue:0.8, alpha:1)
    var shouldDrawBottomBorder : Bool = true
    var shouldDrawTopBorder : Bool = true

    override func draw(_ rect: CGRect) {

        guard let ctx = UIGraphicsGetCurrentContext() else {
            return
        }

        ctx.setLineWidth(0.5)
        ctx.setStrokeColor(borderColor.cgColor)

        if shouldDrawTopBorder {
            ctx.move(to: CGPoint.zero)
            ctx.addLine(to: CGPoint(x: frame.width, y: 0))
        }

        if shouldDrawBottomBorder {
            ctx.move(to: CGPoint(x: 0, y: frame.height))
            ctx.addLine(to: CGPoint(x: frame.width, y: frame.height))
        }
        ctx.strokePath()
    }
}
