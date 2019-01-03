//
//  CircleImageView.swift
//  Moov_Rider
//
//  Created by Munachimso Ugorji on 02/01/2019.
//  Copyright © 2019 Visakh. All rights reserved.
//

import UIKit

class CircleImageView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.makeCircle()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.makeCircle()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.makeCircle()
    }

    private func makeCircle() {
        self.layer.cornerRadius = self.frame.height/2
        self.layer.masksToBounds = true
        self.clipsToBounds = true
        self.layoutIfNeeded()
    }

}
