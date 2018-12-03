//
//  ForgetPassWordView.swift
//  Moov_Rider
//
//  Created by Visakh on 19/07/18.
//  Copyright © 2018 Visakh. All rights reserved.
//

import UIKit


protocol forgetPassWordDelegate {
    func didPasswordSubmitPressed(_ values : NSDictionary)
    func didPasswordClosePressed()
}


class ForgetPassWordView: UIView {

     var rDelegate : forgetPassWordDelegate!
    
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var buttonDone: UIButton!
    
    
    override func layoutSubviews() {
        buttonDone.layer.cornerRadius = 9.0
        buttonCancel.layer.cornerRadius = 9.0
        
    }
    @IBAction func btnSubmitTouched(_ sender : UIButton) {
        if textFieldEmail.text?.isEmpty == false{
            if GenericFunctions.isValidEmail(email: textFieldEmail.text!)
            {
                rDelegate.didPasswordSubmitPressed(["email": textFieldEmail.text!])
            }else{
                rDelegate.didPasswordSubmitPressed(["email": ""])
            }
            
        }else{
            rDelegate.didPasswordSubmitPressed(["email": ""])
            
        }
        
        
        
    }
  
    
    @IBAction func btnCloseTouched(_ sender : UIButton) {
        rDelegate.didPasswordClosePressed()
    }

}
