//
//  LandingPageViewController.swift
//  Moov_Rider
//
//  Created by Henry Chukwu on 12/6/18.
//  Copyright © 2018 Visakh. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit

class LandingPageViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {

    @IBOutlet weak var signinButton: UIButton!
    @IBOutlet weak var createNewAccountButton: UIButton!

    var appDelegate: AppDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        signinButton.layer.cornerRadius = 25.0
        signinButton.layer.masksToBounds = true
        createNewAccountButton.layer.cornerRadius = 25.0
        createNewAccountButton.layer.masksToBounds = true
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }

    @IBAction func signinButtonPressed(_ sender: Any) {
        let loginRootVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginRootViewController") as! LoginRootViewController
        self.navigationController?.pushViewController(loginRootVC, animated: true)
    }

    @IBAction func createAccountButtonPressed(_ sender: Any) {
        let loginRootVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginRootViewController") as! LoginRootViewController
        loginRootVC.selectedPageIndex = 1
        self.navigationController?.pushViewController(loginRootVC, animated: true)
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

}
