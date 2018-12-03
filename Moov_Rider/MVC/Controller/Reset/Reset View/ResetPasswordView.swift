//
//  ResetPasswordView.swift
//  Spourtfy
//
//  Created by Vishnu's Mac on 19/07/18.
//  Copyright © 2018 Vishnu M P. All rights reserved.
//

import UIKit

protocol ResetPasswordDelegate {
    func didPasswordSubmitPressed(_ values : NSDictionary)
    func didPasswordClosePressed()
}

protocol ResetPhoneNumberDelegate {
    func didPhoneSubmitPressed(_ values : NSDictionary)
    func didPhoneClosePressed()
}

protocol ResetEmailDelegate {
    func didEmailSubmitPressed(_ values : NSDictionary)
    func didEmailClosePressed()
}

//MARK:- Reset Password View
class ResetPasswordView: UIView {

    @IBOutlet weak var txtFldOldPassword             : UITextField?
    @IBOutlet weak var txtFldNewPassword             : UITextField?
    @IBOutlet weak var txtFldConfirmPassword         : UITextField?
    
    var rDelegate : ResetPasswordDelegate!
  

    @IBAction func btnSubmitTouched(_ sender : UIButton) {
        var  dict = NSDictionary()
        if txtFldOldPassword?.hasText == true && txtFldNewPassword?.hasText == true && txtFldConfirmPassword?.hasText == true {
            dict = ["old_password" : txtFldOldPassword?.text!,"new_password" : txtFldNewPassword?.text!,"new_confirmpassword" : txtFldConfirmPassword?.text!]
        }else {
            dict = ["old_password" : "","new_password" : "","new_confirmpassword" : ""]
        }
        
        rDelegate.didPasswordSubmitPressed(dict)
    }
    
    
    @IBAction func btnCloseTouched(_ sender : UIButton) {
        rDelegate.didPasswordClosePressed()
    }

}


//MARK:- Reset PhoneNumber View
class ResetPhoneNumberView: UIView {
   
    
    
    @IBOutlet weak var txtFldNumber                  : UITextField!
    @IBOutlet weak var txtFldOTP                     : UITextField!
    @IBOutlet weak var textFieldCountryCode: UITextField!
    
    var rDelegate : ResetPhoneNumberDelegate!

    
    @IBAction func btnSubmitTouched(_ sender : UIButton) {
        rDelegate.didPhoneSubmitPressed(NSDictionary())
    }
    
    @IBAction func btnCloseTouched(_ sender : UIButton) {
        rDelegate.didPhoneClosePressed()
    }
    @IBAction func buttonCoutryCodeAction(_ sender: UIButton) {
        
        
    }
    
    
}


//MARK:- Reset Email View
class ResetEmailView: UIView {
    
    @IBOutlet weak var txtFldOldEmail                 : UITextField!
    @IBOutlet weak var txtFldNewEmail                 : UITextField!
    
    var rDelegate : ResetEmailDelegate!

    
    
    @IBAction func btnSubmitTouched(_ sender : UIButton) {
        var  dict = NSDictionary()
        if txtFldOldEmail.hasText == true && txtFldNewEmail.hasText == true {
            dict = ["old_email" : txtFldOldEmail.text!,"new_email" : txtFldNewEmail.text!]
        }else {
             dict = ["old_email" : "","new_email" : ""]
        }
        rDelegate.didEmailSubmitPressed(dict)
    }
    
    @IBAction func btnCloseTouched(_ sender : UIButton) {
        rDelegate.didEmailClosePressed()
    }

    
    
}
