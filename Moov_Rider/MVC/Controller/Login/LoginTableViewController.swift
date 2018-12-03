//
//  LoginTableViewController.swift
//  Moov_Rider
//  Created by Visakh on 17/07/18.
//  Copyright © 2018 Visakh. All rights reserved.
//

import UIKit
import GoogleSignIn
import SDWebImage
import FBSDKLoginKit

let kScreenWidth    = UIScreen.main.bounds.width
let kScreenHeight   = UIScreen.main.bounds.height
class LoginTableViewController: UITableViewController, UITextFieldDelegate, GIDSignInUIDelegate, GIDSignInDelegate {

    @IBOutlet weak var viewUsernameTxtFld           : UIView!
    @IBOutlet weak var textFieldUsername            : UITextField!
    @IBOutlet weak var textFieldPassword            : UITextField!
    @IBOutlet weak var viewPasswordTxtFld           : UIView!
    @IBOutlet weak var buttonSignin                 : UIButton!
    @IBOutlet var forgetPassWordView                : ForgetPassWordView!
    var deviceToken                                 : String!
    var appDelegate                                 : AppDelegate!
    var activeTextfiled                             : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(receiveToggleAuthUINotification(_:)),
                                               name: NSNotification.Name(rawValue: "ToggleAuthUINotification"),
                                               object: nil)
        self.addDoneButtonOnKeyboard()
        
   // self.navigationController?.setNavigationBarHidden(true, animated: false)
        //viewUsernameTxtFld.setTopRoundedCorners()
       //viewPasswordTxtFld.setBottomRoundedCorners()
        viewUsernameTxtFld.layer.borderColor = UIColor.lightGray.cgColor
        viewUsernameTxtFld.layer.borderWidth = 1.0
        viewPasswordTxtFld.layer.borderColor = UIColor.lightGray.cgColor
        viewPasswordTxtFld.layer.borderWidth = 1.0
        viewUsernameTxtFld.layer.masksToBounds = true
        viewPasswordTxtFld.layer.masksToBounds = true
        buttonSignin.layer.cornerRadius = 8.0
        buttonSignin.layer.masksToBounds = true
        paddingTextFields()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(keyboardHide))
        self.view.addGestureRecognizer(tapGesture)
        
    }
    func paddingTextFields()  {
        textFieldUsername.leftViewMode = .always
        let imageView = UIImageView(frame:CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.image = #imageLiteral(resourceName: "user")
        let paddingView = UIView(frame:CGRect(x: 0, y: 0, width: 40, height: textFieldPassword.frame.height))
        let paddingViewV = UIView(frame:CGRect(x: 0, y: 0, width: 40, height: textFieldUsername.frame.height))
       // paddingView.backgroundColor = UIColor(red: 245/255, green: 241/255, blue: 242/255, alpha: 1.0)
        imageView.center = paddingView.center
        paddingView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        paddingViewV.addSubview(paddingView)
        paddingViewV.backgroundColor = UIColor.clear
        textFieldUsername.leftView = paddingViewV
        textFieldPassword.leftViewMode = .always
        let imageView1 = UIImageView(frame:CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView1.image = #imageLiteral(resourceName: "pass-1")
        let paddingView1 = UIView(frame:CGRect(x: 0, y: 0, width: 40, height: textFieldPassword.frame.height))
        let paddingViewW = UIView(frame:CGRect(x: 0, y: 0, width: 40, height: textFieldPassword.frame.height))
       // paddingView1.backgroundColor = UIColor(red: 245/255, green: 241/255, blue: 242/255, alpha: 1.0)
        imageView1.center = paddingView1.center
        paddingView1.addSubview(imageView1)
        imageView1.contentMode = .scaleAspectFit
        paddingViewW.addSubview(paddingView1)
        paddingViewW.backgroundColor = UIColor.clear
        textFieldPassword.leftView = paddingViewW
        
        //View top rounded border
        viewUsernameTxtFld.clipsToBounds          = true
        viewUsernameTxtFld.layer.cornerRadius     = 15
        if #available(iOS 11.0, *) {
            viewUsernameTxtFld.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        } else {
            // Fallback on earlier versions
        }
        //View botton rounded border
        viewPasswordTxtFld.clipsToBounds      = true
        viewPasswordTxtFld.layer.cornerRadius = 15
        if #available(iOS 11.0, *) {
            viewPasswordTxtFld.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        } else {
            // Fallback on earlier versions
        }
        
        
    }
//MARK Button Actions
    @IBAction func buttonSigninAction(_ sender: UIButton) {
        if textFieldUsername.text?.isEmpty == false{
            if textFieldPassword.text?.isEmpty == false{
                self.loginWithEmail()
            }else{
                GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Please enter your password")
            }
        }else{
            GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Please enter your username")
        }
    }
    @IBAction func buttonForgetPasswordAction(_ sender: UIButton) {
        
        self.addResetView(self.forgetPassWordView, frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 60 , height: 200))
        self.forgetPassWordView.rDelegate = self
        forgetPassWordView.textFieldEmail.text = ""
        
    }
    @IBAction func buttonSignUpAction(_ sender: UIButton) {
        let registrationVC = self.storyboard?.instantiateViewController(withIdentifier: "RegistrationTableViewController") as! RegistrationTableViewController
        self.navigationController?.pushViewController(registrationVC, animated: true)
    }
    @IBAction func buttonGoogleSignIn(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().signIn()
    }
    @IBAction func buttonFacebookSignInAction(_ sender: UIButton) {
        
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        loginManager.loginBehavior = .web
        loginManager.logIn(withReadPermissions: ["public_profile","email"], from: self) { (result, error) in
            if error != nil {
                NSLog("*************Process error*************")
                GenericFunctions.showAlertView(targetVC: self, title: "Message", message: (error?.localizedDescription)!)
            }
            else if (result?.isCancelled)! {
                NSLog("*************Cancelled*************")
            }
            else {
                NSLog("*************Logged in*************")
                if((FBSDKAccessToken.current()) != nil){
                    //SVProgressHUD.show()
                    let hud = GenericFunctions.showJHud(target: self)
                    FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name,email"]).start(completionHandler: { (connection, result, error) -> Void in
                        if (error == nil){
                            let dataDict: NSMutableDictionary = NSMutableDictionary()
                            dataDict.setValue((result as! NSDictionary).value(forKey: "email") as! String, forKey: "email_id")
                            dataDict.setValue((result as! NSDictionary).value(forKey: "id") as! String, forKey: "id")
                            dataDict.setValue((result as! NSDictionary).value(forKey: "name") as! String, forKey: "name")
                            dataDict.setValue("facebook", forKey: "login_type")
                            let response = result as! NSDictionary
                            let fbid  = (result as! NSDictionary)["id"] as! String
                            let kFBImageLink =  "https://graph.facebook.com/"
                            let imageUrl = String(format: ("%@%@/picture?type=square&height=150&width=150&return_ssl_resources=1&access_token=\(FBSDKAccessToken.current().tokenString!)" as NSString) as String, kFBImageLink, fbid)
                            let newImageVIew = UIImageView()
                            newImageVIew.frame = UIScreen.main.bounds
                            self.view.addSubview(newImageVIew)
                            newImageVIew.isHidden = true
                            //  newImageVIew.sd_setImage(with: NSURL(string: imageUrl)! as URL)
                            let url = URL(string: imageUrl)!
                            var imageData = Data()
                            let request = URLRequest(url: url)
                            newImageVIew.sd_setImage(with: url, placeholderImage: UIImage(), options: .highPriority, completed: { (image, error, cache, url) in
                                //imageData = UIImageJPEGRepresentation(image!, 1.0)!
                            })
                            
                            self.checkSocialLogin(provider: "facebook", uId: fbid) { (success) in
                                if success != true {
                                    let selectUniversityVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectPreferredInstitutionViewController") as! SelectPreferredInstitutionViewController
                                    selectUniversityVC.firstName = response["name"] as! String
                                    selectUniversityVC.authUID = response["id"] as! String
                                    selectUniversityVC.emailID = response["email"] as! String
                                    selectUniversityVC.authMode = "social"
                                    selectUniversityVC.authProvider = "facebook"
                                    selectUniversityVC.password = ""
                                    selectUniversityVC.imageUrl = imageUrl
                                    selectUniversityVC.surName = ""
                                    selectUniversityVC.imageData = Data()
                                    self.navigationController?.pushViewController(selectUniversityVC, animated: true)
                                }
                            }
                        }
                        
                    })
                    
                    
                }
            }
        }
        
    }
    
    //MARK: ForgetPassWordUIView
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
    //Google SignIn Delegate
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if user != nil {
            googleSignIn(user: user)
        }
        if let error = error {
            // ...
            return
        }
        guard let authentication = user.authentication else { return }
        
        //  let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
        // accessToken: authentication.accessToken)
        // ...
    }
    
    
    //MARK:- Func googleLogin
    func googleSignIn(user : GIDGoogleUser) {
        
        let dict : NSMutableDictionary = NSMutableDictionary()
        dict.setValue(user.userID, forKey: "id")
        dict.setValue(user.profile.email, forKey: "email_id")
        dict.setValue(user.profile.name, forKey: "name")
        dict.setValue("google", forKey: "login_type")
        let newImageVIew = UIImageView()
        newImageVIew.frame = UIScreen.main.bounds
        self.view.addSubview(newImageVIew)
        newImageVIew.isHidden = true
        let gAuthUid = user.userID!
        let gFirstName = user.profile.name!
        let gSUrName = user.profile.familyName!
        let gGivenName = user.profile.givenName!
        let gGmail = user.profile.email!
        
        let gImageUrl = user.profile.imageURL(withDimension: 100)
        var  imageData = Data()
        //let request = URLRequest(url: gImageUrl!)
        newImageVIew.sd_setImage(with: gImageUrl, placeholderImage: UIImage(), options: .highPriority) { (image, error, cache, url) in
            imageData = UIImageJPEGRepresentation(image!, 1.0)!
        }
        
        self.checkSocialLogin(provider: "google", uId: gAuthUid) { (success) in
            if success != true {
                let selectUnivVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectPreferredInstitutionViewController")as! SelectPreferredInstitutionViewController
                selectUnivVC.firstName = gFirstName
                selectUnivVC.surName = gSUrName
                selectUnivVC.emailID = gGmail
                selectUnivVC.imageData = imageData
                selectUnivVC.authMode = "social"
                selectUnivVC.authProvider = "google"
                selectUnivVC.authUID = gAuthUid
                selectUnivVC.password = ""
                selectUnivVC.imageUrl = gImageUrl?.absoluteString
                self.navigationController?.pushViewController(selectUnivVC, animated: true)
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.present(viewController, animated: true) {
            
        }
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        viewController.dismiss(animated: true) {
            
        }
    }
    
    @objc func receiveToggleAuthUINotification(_ notification: NSNotification) {
        if notification.name.rawValue == "ToggleAuthUINotification" {
            if notification.userInfo != nil {
                guard let userInfo = notification.userInfo as? [String:String] else { return }
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK:- API Login with email
    func loginWithEmail()  {
        let hud = GenericFunctions.showJHud(target: self)
        /*if UserDefaults.value(forKey: "deviceToken") as? String != nil{
         deviceToken = UserDefaults.value(forKey: "deviceToken") as! String
         }else{
         deviceToken =
         }*/
        let params : NSDictionary!
        if appDelegate.deviceTokenStr != nil{
            params = ["email":self.textFieldUsername.text!,"password": self.textFieldPassword.text!,"device_type":"iOS","device_id":appDelegate.deviceTokenStr!,"push_token": appDelegate.deviceTokenStr!,"app_version":"1.2"]
        }else{
            params = ["email":self.textFieldUsername.text!,"password": self.textFieldPassword.text!,"device_type":"iOS","device_id":"","push_token": "","app_version":"1.2"]
        }
        
        
        AlamofireSubclass.parseLinkUsingPostMethod("auth/login/email", with: params, completion: { (success, response, error) in
            
            GenericFunctions.hideJHud(hudView: hud)
            if success  == true {
                if response!["message"] as! String == "login success"
                {
                    let userDict = response!["data"] as! NSDictionary
                    User.current.initWithDictionary(dictionary: userDict)
                    User.saveLoggedUserdetails(dictDetails: userDict)
                    let homePage = self.storyboard?.instantiateViewController(withIdentifier: "EnterDestinationViewController")
                        as! EnterDestinationViewController
                    let navVC = UINavigationController(rootViewController: homePage)
                    let sideVC = self.storyboard?.instantiateViewController(withIdentifier: "SideMenuTableViewController") as! SideMenuTableViewController
                    let mfContainer = MFSideMenuContainerViewController.container(withCenter: navVC, leftMenuViewController: sideVC, rightMenuViewController: nil)
                    UIApplication.shared.keyWindow?.rootViewController = mfContainer
                    
                }else{
                    GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Please enter a valid username and password")
                }
            }else{
                GenericFunctions.showAlertView(targetVC: self, title: "Message", message: (error?.localizedDescription)!)
            }
        })
    }
    
    //MARK: Check social Login
    func checkSocialLogin(provider : String, uId : String, completion:@escaping (Bool) -> Void) {
        let params: NSDictionary!
       
        params = ["provider": provider, "uid": uId, "device_id": appDelegate.deviceTokenStr!, "app_version":"1.0", "device_type": "iOS"]
        let hud = GenericFunctions.showJHud(target: self)
        AlamofireSubclass.parseLinkUsingPostMethod("auth/social_login", with: params!) { (success, response, error) in
            hud.hide()
            if success  == true {
                if response!["message"] as! String == "login success"
                {
                    completion(true)
                    let userDict = response!["data"] as! NSDictionary
                    User.current.initWithDictionary(dictionary: userDict)
                    User.saveLoggedUserdetails(dictDetails: userDict)
                    let homePage = self.storyboard?.instantiateViewController(withIdentifier: "EnterDestinationViewController")
                        as! EnterDestinationViewController
                    let navVC = UINavigationController(rootViewController: homePage)
                    let sideVC = self.storyboard?.instantiateViewController(withIdentifier: "SideMenuTableViewController") as! SideMenuTableViewController
                    let mfContainer = MFSideMenuContainerViewController.container(withCenter: navVC, leftMenuViewController: sideVC, rightMenuViewController: nil)
                    UIApplication.shared.keyWindow?.rootViewController = mfContainer
                    
                }else{
                     completion(false)
                   // GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Please enter a valid username and password")
                }
            }else{
                GenericFunctions.showAlertView(targetVC: self, title: "Message", message: (error?.localizedDescription)!)
            }
            
        }
    }
    
    //MARK:- Add Done Button
    
    
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
        textFieldUsername.inputAccessoryView = doneToolbar
        textFieldPassword.inputAccessoryView = doneToolbar
       
    }
    @objc func doneButtonAction() {
        
        textFieldUsername.resignFirstResponder()
        textFieldPassword.resignFirstResponder()
        
    }
    
    @objc func keyboardHide()  {
        textFieldUsername.resignFirstResponder()
        textFieldPassword.resignFirstResponder()
    }
    
    //MARK:- Textfield Delegates
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextfiled = textField
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if activeTextfiled.tag == 1{
            textFieldPassword.becomeFirstResponder()
        }else{
            activeTextfiled.resignFirstResponder()
        }
        
        
        return true
    }
   
}


extension UIView {
    
    func setTopRoundedCorners() {
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .topRight],cornerRadii: CGSize(width: kScreenWidth/20, height: 20.0)).cgPath
        maskLayer.strokeColor = UIColor.lightGray.cgColor
        self.layer.mask = maskLayer
    }
    
    func setBottomRoundedCorners() {
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.bottomLeft, .bottomRight],cornerRadii: CGSize(width: kScreenWidth/20, height: 50.0)).cgPath
        maskLayer.strokeColor = UIColor.lightGray.cgColor

        self.layer.mask = maskLayer
    }
}
//MARK:- forgetPassWordDelegate
extension LoginTableViewController : forgetPassWordDelegate {
    func didPasswordSubmitPressed(_ values: NSDictionary) {
        if values["email"] as! NSString != ""{
            forgetPassWord(email: (values["email"] as! NSString) as String)
        }else{
            GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Please enter a valid email id")
        }
     }
    
    func didPasswordClosePressed() {
        self.forgetPassWordView.removeFromSuperview()
        self.removeBlurView()
    }
    
    func forgetPassWord(email: String)  {
        let hud = GenericFunctions.showJHud(target: self)
        AlamofireSubclass.parseLinkUsingPostMethod("auth/forgot", with: ["email": email]) { (success, response, error) in
            hud.hide()
            if success  == true {
                if response!["message"] as! String == "A new password will be send to you if mail exist in our server!"
                {
                    GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "A new password will be send to you if mail exist in our server!")
                    self.forgetPassWordView.removeFromSuperview()
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
