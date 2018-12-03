//
//  PaymentListTableViewCell.swift
//  Spourtfy
//
//  Created by Vishnu's Mac on 19/07/18.
//  Copyright © 2018 Vishnu M P. All rights reserved.
//
import UIKit

class PaymentListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bgView           : UIView!
    @IBOutlet weak var lblSource        : UILabel!
    @IBOutlet weak var lblDestination   : UILabel!
    @IBOutlet weak var lblDate          : UILabel!
    @IBOutlet weak var lblTime          : UILabel!
    @IBOutlet weak var lblSeats         : UILabel!
    @IBOutlet weak var lblPrice         : UILabel!
    @IBOutlet weak var buttonPaymentStatus: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupView()
    }
    
    func setupView() {
        self.bgView.layer.cornerRadius = 10.0
        self.bgView.layer.borderWidth = 0.8
        self.bgView.layer.borderColor = UIColor.lightGray.cgColor
        self.bgView.layer.masksToBounds = true
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
