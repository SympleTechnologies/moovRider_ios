//
//  RegistrationTableViewController.swift
//  Moov_Rider
//
//  Created by Visakh on 17/07/18.
//  Copyright © 2018 Visakh. All rights reserved.
//

import UIKit


class RegistrationTableViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var viewFirsnameTxtFld                   : UIView!
    @IBOutlet weak var viewSurnameTxtFld                    : UIView!
    @IBOutlet weak var viewEmailTxtFld                      : UIView!
    @IBOutlet weak var textFieldFirstName                   : UITextField!
    @IBOutlet weak var textFieldSurName                     : UITextField!
    @IBOutlet weak var viewPasswordTxtFld                   : UIView!
    @IBOutlet weak var textFieldEmail                       : UITextField!
    @IBOutlet weak var viewConfirmPasswordTxtFld            : UIView!
    @IBOutlet weak var textFieldPassword                    : UITextField!
    @IBOutlet weak var textFieldConfirmPassword             : UITextField!
    @IBOutlet weak var buttonSignin                         : UIButton!
    var activeTextfield                                     : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(keyboardHide))
        self.view.addGestureRecognizer(tapGesture)
        self.addDoneButtonOnKeyboard()
    }
    func setupUI()  {
        viewFirsnameTxtFld.layer.borderColor = UIColor.lightGray.cgColor
        viewFirsnameTxtFld.layer.borderWidth = 1.0
        viewFirsnameTxtFld.layer.masksToBounds = true
        viewSurnameTxtFld.layer.borderColor = UIColor.lightGray.cgColor
        viewSurnameTxtFld.layer.borderWidth = 1.0
        viewSurnameTxtFld.layer.masksToBounds = true
        viewEmailTxtFld.layer.borderColor = UIColor.lightGray.cgColor
        viewEmailTxtFld.layer.borderWidth = 1.0
        viewEmailTxtFld.layer.masksToBounds = true
        viewPasswordTxtFld.layer.borderColor = UIColor.lightGray.cgColor
        viewPasswordTxtFld.layer.borderWidth = 1.0
        viewPasswordTxtFld.layer.masksToBounds = true
        viewConfirmPasswordTxtFld.layer.borderColor = UIColor.lightGray.cgColor
        viewConfirmPasswordTxtFld.layer.borderWidth = 1.0
        viewConfirmPasswordTxtFld.layer.masksToBounds = true
        //viewFirsnameTxtFld.setTopRoundedCorners()
        //viewConfirmPasswordTxtFld.setBottomRoundedCorners()
        
        textFieldFirstName.leftViewMode = .always
        let imageView0 = UIImageView(frame:CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView0.image = #imageLiteral(resourceName: "user")
        let paddingView0 = UIView(frame:CGRect(x: 0, y: 0, width: 40, height: textFieldFirstName.frame.height))
        let paddingViewV0 = UIView(frame:CGRect(x: 0, y: 0, width: 40, height: textFieldFirstName.frame.height))
        imageView0.center = paddingView0.center
        paddingView0.addSubview(imageView0)
        imageView0.contentMode = .scaleAspectFit
        paddingViewV0.addSubview(paddingView0)
        paddingViewV0.backgroundColor = UIColor.clear
        textFieldFirstName.leftView = paddingViewV0
        
        
        textFieldSurName.leftViewMode = .always
        let imageView1 = UIImageView(frame:CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView1.image = #imageLiteral(resourceName: "user")
        let paddingView1 = UIView(frame:CGRect(x: 0, y: 0, width: 40, height: textFieldSurName.frame.height))
        let paddingViewV1 = UIView(frame:CGRect(x: 0, y: 0, width: 40, height: textFieldSurName.frame.height))
        imageView1.center = paddingView1.center
        paddingView1.addSubview(imageView1)
        imageView1.contentMode = .scaleAspectFit
        paddingViewV1.addSubview(paddingView1)
        paddingViewV1.backgroundColor = UIColor.clear
        textFieldSurName.leftView = paddingViewV1
        
        textFieldEmail.leftViewMode = .always
        let imageView2 = UIImageView(frame:CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView2.image = #imageLiteral(resourceName: "mail")
        let paddingView2 = UIView(frame:CGRect(x: 0, y: 0, width: 40, height: textFieldEmail.frame.height))
        let paddingViewV2 = UIView(frame:CGRect(x: 0, y: 0, width: 40, height: textFieldEmail.frame.height))
        imageView2.center = paddingView2.center
        paddingView2.addSubview(imageView2)
        imageView2.contentMode = .scaleAspectFit
        paddingViewV2.addSubview(paddingView2)
        paddingViewV2.backgroundColor = UIColor.clear
        textFieldEmail.leftView = paddingViewV2
        
        textFieldPassword.leftViewMode = .always
        let imageView3 = UIImageView(frame:CGRect(x: 0, y: 0, width: 30, height: 35))
        imageView3.image = #imageLiteral(resourceName: "pass-1")
        let paddingView3 = UIView(frame:CGRect(x: 0, y: 0, width: 40, height: textFieldPassword.frame.height))
        let paddingViewV3 = UIView(frame:CGRect(x: 0, y: 0, width: 40, height: textFieldPassword.frame.height))
        imageView3.center = paddingView3.center
        paddingView3.addSubview(imageView3)
        imageView3.contentMode = .scaleAspectFit
        paddingViewV3.addSubview(paddingView3)
        paddingViewV3.backgroundColor = UIColor.clear
        textFieldPassword.leftView = paddingViewV3
        
        textFieldConfirmPassword.leftViewMode = .always
        let imageView4 = UIImageView(frame:CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView4.image = #imageLiteral(resourceName: "pass-1")
        let paddingView4 = UIView(frame:CGRect(x: 0, y: 0, width: 40, height: textFieldConfirmPassword.frame.height))
        let paddingViewV4 = UIView(frame:CGRect(x: 0, y: 0, width: 40, height: textFieldConfirmPassword.frame.height))
        imageView4.center = paddingView4.center
        paddingView4.addSubview(imageView4)
        imageView4.contentMode = .scaleAspectFit
        paddingViewV4.addSubview(paddingView4)
        paddingViewV4.backgroundColor = UIColor.clear
        textFieldConfirmPassword.leftView = paddingViewV4
        
        buttonSignin.layer.cornerRadius = 10.0
        buttonSignin.layer.masksToBounds = true
        
        
        let btnMenu = UIButton(type: .custom)
        btnMenu.setImage(#imageLiteral(resourceName: "Back_Button_3x"), for: .normal)
        btnMenu.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        btnMenu.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        let item3 = UIBarButtonItem(customView: btnMenu)
        self.navigationItem.setLeftBarButton(item3, animated: true)
        self.navigationItem.title = "Moov"
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.red]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        //UITextfield top rounded border
        
        viewFirsnameTxtFld.clipsToBounds          = true
        viewFirsnameTxtFld.layer.cornerRadius     = 15
        if #available(iOS 11.0, *) {
            viewFirsnameTxtFld.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        } else {
            // Fallback on earlier versions
        }
        
        //UITextfield botton rounded border
        
        viewConfirmPasswordTxtFld.clipsToBounds      = true
        viewConfirmPasswordTxtFld.layer.cornerRadius = 15
        if #available(iOS 11.0, *) {
            viewConfirmPasswordTxtFld.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        } else {
            // Fallback on earlier versions
        }
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
    //MARK:- Toggle SideMenu
    @objc func backButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  
}
