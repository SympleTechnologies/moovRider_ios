//
//  ResetDetailsViewController.swift
//
//
//  Created by Visakh's Mac on 19/07/18.
//  Copyright © 2018 Visakh M P. All rights reserved.



import UIKit

class ResetDetailsViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var viewResetPassword    : ResetPasswordView!
    @IBOutlet weak var viewResetPhone       : ResetPhoneNumberView!
    @IBOutlet weak var viewResetEmail       : ResetEmailView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
            self.setupUI()
    }
    func setupUI()  {
        let btnMenu = UIButton(type: .custom)
        btnMenu.setImage(#imageLiteral(resourceName: "Back_Button_3x"), for: .normal)
        btnMenu.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        btnMenu.addTarget(self, action: #selector(sideMenuAction), for: .touchUpInside)
        let item3 = UIBarButtonItem(customView: btnMenu)
        self.navigationItem.setLeftBarButton(item3, animated: true)
        
        
        self.navigationItem.title = "Settings"
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.red]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    //MARK:- Toggle SideMenu
    @objc func sideMenuAction() {
        menuContainerViewController.toggleLeftSideMenuCompletion(nil)
    }
    
    @IBAction func btnResetTouched(_ sender : UIButton) {
        switch sender.tag {
        case 1:
            self.addResetView(self.viewResetPassword, frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 30 , height: 220))
            self.viewResetPassword.rDelegate = self
            break
        case 2:
           /* self.addResetView(self.viewResetPhone, frame: CGRect(x: 0, y: 0, width: 250 , height: 190))
            self.viewResetPhone.rDelegate = self
            break*/
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let popupVC = storyboard.instantiateViewController(withIdentifier: "UpdatePhoneNumberViewController") as! UpdatePhoneNumberViewController
            popupVC.modalPresentationStyle = .overCurrentContext
            popupVC.modalTransitionStyle = .crossDissolve
            popupVC.preferredContentSize = CGSize(width: self.view.frame.width - 30, height: 300)
            let pVC = popupVC.popoverPresentationController
            pVC?.permittedArrowDirections = .any
            pVC?.delegate = self
            pVC?.sourceView = sender
            pVC?.sourceRect = CGRect(x: 100, y: 100, width: 1, height: 1)
             let navController = UINavigationController(rootViewController: popupVC)
            present(navController, animated: true, completion: nil)
            //self.navigationController?.pushViewController(popupVC, animated: true)
            
            break
        case 3:
            self.addResetView(self.viewResetEmail, frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 30 , height: 200))
            self.viewResetEmail.rDelegate = self
            break
        default:
            break
        }
    }
    @IBAction func buttonLogOutAction(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Message", message: "Do you want to logout.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction((UIAlertAction(title: "OK", style: .destructive, handler: {(action) -> Void in
            DispatchQueue.main.async {
                User.logOutCurrentUser()
                let LoginTableVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginTableViewController") as! LoginTableViewController
                let navVC = UINavigationController(rootViewController: LoginTableVC)
                (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = navVC
                
            }
        })))
        alert.addAction((UIAlertAction(title: "Cancel", style: .destructive, handler: {(action) -> Void in
        })))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func addResetView(_ view : UIView , frame : CGRect) {
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            let blurEffect                    = UIBlurEffect(style: UIBlurEffectStyle.dark)
            let blurEffectView                = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame              = self.view.bounds
            blurEffectView.autoresizingMask   = [.flexibleWidth, .flexibleHeight]
            
            self.view.addSubview(blurEffectView)
        } else {
            self.view.backgroundColor = UIColor.white
        }
        view.frame = frame
        view.center = self.view.center
        view.layer.cornerRadius = 5.0
        view.layer.masksToBounds = true
        self.view.addSubview(view)
        view.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }) { (sucess) in
        }
    }

    func removeBlurView() {
        for view in (self.view.subviews) {
            if view is UIVisualEffectView {
                view.removeFromSuperview()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//MARK:- ResetPasswordDelegate
extension ResetDetailsViewController : ResetPasswordDelegate {
    func didPasswordSubmitPressed(_ values: NSDictionary) {
        
        let oldPassword = values["old_password"] as! String
        let newPassword = values["new_password"] as! String
        let newConfirmPassword = values["new_confirmpassword"] as! String
        
        if oldPassword != "" && newPassword != "" && newConfirmPassword != "" {
            if newPassword == newConfirmPassword {
                self.resetPassWord(oldPassword: oldPassword, newPassword: newPassword)
            }else{
                GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Entered password is missmatch")
            }
            
        }else{
            GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Please fill all the fields")
        }
        
       // self.viewResetPassword.removeFromSuperview()
        //self.removeBlurView()
        
    }
    
    func didPasswordClosePressed() {
        self.viewResetPassword.removeFromSuperview()
        self.removeBlurView()
    }
    func resetPassWord(oldPassword: String, newPassword: String)  {
        let hud = GenericFunctions.showJHud(target: self)
        AlamofireSubclass.parseLinkUsingPostMethod("update/password", with: ["userid": String(User.current.user_details!.u_id!),"old_password":oldPassword, "new_password": newPassword]) { (success, response, error) in
            hud.hide()
            if success  == true {
                if response!["message"] as! String == "Password Updated Successfully"
                {
                    GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Password Updated Successfully")
                    self.viewResetPassword.removeFromSuperview()
                    self.removeBlurView()
                    
                }else{
                    GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Please try again")
                }
            }else{
                GenericFunctions.showAlertView(targetVC: self, title: "Message", message: (error?.localizedDescription)!)
            }
        }
    }
}


//MARK:- ResetPhoneNumberDelegate
extension ResetDetailsViewController : ResetPhoneNumberDelegate {
    func didPhoneSubmitPressed(_ values: NSDictionary) {
        self.viewResetPhone.removeFromSuperview()
        self.removeBlurView()
        
    }
    
    func didPhoneClosePressed() {
        self.viewResetPhone.removeFromSuperview()
        self.removeBlurView()
    }
    
}

//MARK:- ResetEmailDelegate
extension ResetDetailsViewController : ResetEmailDelegate {
    func didEmailSubmitPressed(_ values: NSDictionary) {
        let oldEmail = values["old_email"] as! String
        let newEmail = values["new_email"] as! String
        if oldEmail != "" && newEmail != "" {
            if GenericFunctions.isValidEmail(email: oldEmail) == true  && GenericFunctions.isValidEmail(email: newEmail) == true {
                self.resetEmail(oldEmail: oldEmail, newEmail: newEmail)
            }else {
                GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Please enter vaild emails")
            }
        }else {
            GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Please enter all the fields")
        }
    }
    
    func didEmailClosePressed() {
        self.viewResetEmail.removeFromSuperview()
        self.removeBlurView()
    }
    
    func resetEmail(oldEmail: String, newEmail: String)  {
        let hud = GenericFunctions.showJHud(target: self)
        AlamofireSubclass.parseLinkUsingPostMethod("update/email", with: ["userid": String(User.current.user_details!.u_id!),"old_email":oldEmail, "new_email": newEmail]) { (success, response, error) in
            hud.hide()
            if success  == true {
                if response!["message"] as! String == "Email Updated Successfully"                 {
                    GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Email Updated Successfully")
                    self.viewResetEmail.removeFromSuperview()
                    self.removeBlurView()
                }else {
                    GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Email Updated failed")
                }
            }else{
                GenericFunctions.showAlertView(targetVC: self, title: "Message", message: (error?.localizedDescription)!)
            }
        }
    }
    
    //reset PhoneNumber
    func resetPhoneNumber(phoneNumber: String, countryCode: String)  {
        let hud = GenericFunctions.showJHud(target: self)
        AlamofireSubclass.parseLinkUsingPostMethod("update/phone/otp", with: ["userid": String(User.current.user_details!.u_id!),"phone":phoneNumber, "phone_country": countryCode]) { (success, response, error) in
            hud.hide()
            if success  == true {
                if response!["message"] as! String == "Email Updated Successfully"                 {
                    GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Email Updated Successfully")
                    self.viewResetEmail.removeFromSuperview()
                    self.removeBlurView()
                }else {
                    GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Please try again")
                }
            }else{
                GenericFunctions.showAlertView(targetVC: self, title: "Message", message: (error?.localizedDescription)!)
            }
        }
    }
}

/*
 `Android`
 email:  
 password: sympleincdevs18
 `IOS`
 email: moov.helpdesk@gmail.com
 password: Sympleincdevs18
 */
