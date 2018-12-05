//
//  RegistrationViewController.swift
//  Moov_Rider
//
//  Created by Visakh on 17/07/18.
//  Copyright © 2018 Visakh. All rights reserved.
//

import UIKit


class RegistrationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var topView: BorderView!
    @IBOutlet weak var textFieldFirstName: UITextField!
    @IBOutlet weak var textFieldSurName: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFieldConfirmPassword: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!

    var activeTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        continueButton.layer.cornerRadius = 25.0
        continueButton.layer.masksToBounds = true
        signUpButton.layer.cornerRadius = 25.0
        signUpButton.layer.masksToBounds = true
        topView.shouldDrawBottomBorder = true
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(keyboardHide))
        self.view.addGestureRecognizer(tapGesture)
        self.addDoneButtonOnKeyboard()
    }

    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar  = UIToolbar(frame: CGRect(x:0, y:0, width:320, height:50))
        doneToolbar.barStyle        = UIBarStyle.default
        let flexSpace               = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(doneButtonAction))
        var items           = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        doneToolbar.items   = items
        doneToolbar.sizeToFit()
        textFieldFirstName.inputAccessoryView = doneToolbar
        textFieldSurName.inputAccessoryView = doneToolbar
        textFieldEmail.inputAccessoryView = doneToolbar
        textFieldPassword.inputAccessoryView = doneToolbar
        textFieldConfirmPassword.inputAccessoryView = doneToolbar
    }

    @objc func doneButtonAction() {
       
        textFieldFirstName.resignFirstResponder()
        textFieldSurName.resignFirstResponder()
        textFieldEmail.resignFirstResponder()
        textFieldPassword.resignFirstResponder()
        textFieldConfirmPassword.resignFirstResponder()
        
    }
    //MARK:- Button Actions
    @IBAction func buttonSigninAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonNextActions(_ sender: UIButton) {
        if textFieldFirstName.text?.isEmpty == false {
            if textFieldSurName.text?.isEmpty == false {
                if textFieldEmail.text?.isEmpty == false {
                    if textFieldPassword.text?.isEmpty == false {
                        if textFieldConfirmPassword.text?.isEmpty == false && textFieldConfirmPassword.text == textFieldPassword.text {
                           /* let selectPreferredInstitutionVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectPreferredInstitutionViewController")as! SelectPreferredInstitutionViewController
                            selectPreferredInstitutionVC.firstName = textFieldFirstName.text!
                            selectPreferredInstitutionVC.surName = textFieldSurName.text!
                            selectPreferredInstitutionVC.emailID = textFieldEmail.text!
                            selectPreferredInstitutionVC.password = textFieldPassword.text!
                            selectPreferredInstitutionVC.authMode = ""
                            selectPreferredInstitutionVC.authProvider = ""
                            selectPreferredInstitutionVC.authUID = ""
                            selectPreferredInstitutionVC.imageUrl = ""
                            selectPreferredInstitutionVC.imageData = Data()
                            self.navigationController?.pushViewController(selectPreferredInstitutionVC, animated: true)*/
                            self.chekcEmailExistence()
                        }else{
                            GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Entered password is missmatch")
                        }
                    }else {
                        GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Please fill Password field")
                    }
                }else {
                    GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Please fill Email field")
                }
            }else {
                GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Please fill Surname field")
            }
        }else {
            GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Please fill Firstname field")
        }
    }
    
    
    @objc func keyboardHide()  {
        textFieldFirstName.resignFirstResponder()
        textFieldSurName.resignFirstResponder()
        textFieldEmail.resignFirstResponder()
        textFieldPassword.resignFirstResponder()
        textFieldConfirmPassword.resignFirstResponder()
    }
    //MARK:- API Email existence check
    func chekcEmailExistence()  {
        let hud = GenericFunctions.showJHud(target: self)
        AlamofireSubclass.parseLinkUsingPostMethod("auth/check/email", with: ["email": textFieldEmail.text!]) { (success, response, error) in
            hud.hide()
            if success  == true {
                if response!["message"] as! String == "No emails found"
                {
                    let selectPreferredInstitutionVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectPreferredInstitutionViewController")as! SelectPreferredInstitutionViewController
                    selectPreferredInstitutionVC.firstName = self.textFieldFirstName.text!
                    selectPreferredInstitutionVC.surName = self.textFieldSurName.text!
                    selectPreferredInstitutionVC.emailID = self.textFieldEmail.text!
                    selectPreferredInstitutionVC.password = self.textFieldPassword.text!
                    selectPreferredInstitutionVC.authMode = ""
                    selectPreferredInstitutionVC.authProvider = ""
                    selectPreferredInstitutionVC.authUID = ""
                    selectPreferredInstitutionVC.imageUrl = ""
                    selectPreferredInstitutionVC.imageData = Data()
                    self.navigationController?.pushViewController(selectPreferredInstitutionVC, animated: true)
                   
                }else{
                    GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Email already exist")
                }
            }else{
                GenericFunctions.showAlertView(targetVC: self, title: "Message", message: (error?.localizedDescription)!)
            }
        }
        
        
    }
    
    
    // MARK:- Textfield delegate methods
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextfield = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        
        if activeTextfield.tag == 1{
            textFieldSurName.becomeFirstResponder()
        }else if activeTextfield.tag == 2{
            textFieldEmail.becomeFirstResponder()
        }else if activeTextfield.tag == 3 {
            textFieldPassword.becomeFirstResponder()
        }else if activeTextfield.tag == 4 {
            textFieldConfirmPassword.becomeFirstResponder()
        }else{
            activeTextfield.resignFirstResponder()
        }
        
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  
}
