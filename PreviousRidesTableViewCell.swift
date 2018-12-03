//
//  PreviousRidesTableViewCell.swift
//  Moov_Rider
//
//  Created by Visakh on 05/09/18.
//  Copyright © 2018 Visakh. All rights reserved.
//
import UIKit

class PreviousRidesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var labelDriverName: UILabel!
    
    @IBOutlet weak var viewDriverDetails: UIView!
    @IBOutlet weak var cmStar: CosmosView!
    @IBOutlet weak var buttonCancelRide: UIButton!
    @IBOutlet weak var labelPhoneNumber: UILabel!
    @IBOutlet weak var labelCarName: UILabel!
    @IBOutlet weak var labelDistance: UILabel!
    @IBOutlet weak var labelPlateNumber: UILabel!
    @IBOutlet weak var labelETA: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }
    
    func setupUI()  {
        viewDriverDetails.layer.cornerRadius = 10.0
        viewDriverDetails.layer.borderColor = UIColor.lightGray.cgColor
        viewDriverDetails.layer.borderWidth = 0.5
        viewDriverDetails.layer.masksToBounds = true
        
        imageViewProfile.layer.cornerRadius = 10.0
        imageViewProfile.layer.masksToBounds = true
        
        imageViewProfile.layer.shadowRadius = 3
        imageViewProfile.layer.shadowOpacity = 1.0
        imageViewProfile.layer.shadowColor = UIColor.black.cgColor
        imageViewProfile.layer.shadowOffset = CGSize.zero
        
        imageViewProfile.generateOuterShadow()
        
        buttonCancelRide.layer.cornerRadius = 5.0
        buttonCancelRide.layer.masksToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
