//
//  Generic.swift
//  SafeFunRide
//
//  Created by Vignesh's Mac on 18/05/2017.
//  Copyright © 2017 Srishti. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class GenericFunctions: NSObject {
    var hudView : JHUD!
    
    
    //MARK:- Alert View Controller
    static  func showAlertView(targetVC: UIViewController, title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction((UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in
        })))
        targetVC.present(alert, animated: true, completion: nil)
    }

    //MARK:- Email Validation
    static func isValidEmail(email: String) -> Bool {
        let stricterFilterString:NSString = "[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}"
        let emailRegex:NSString = stricterFilterString
        let emailTest:NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
    
      //MARK:- Store Current User Data
    static func saveLoggedUserdetails(dictDetails : NSDictionary) {
        let data : NSData = NSKeyedArchiver.archivedData(withRootObject: dictDetails) as NSData
        UserDefaults.standard.set(data, forKey: "CurrentUserDetails")
        UserDefaults.standard.synchronize()
    }
    
    class func loadCount(servicename : String , parameters : NSDictionary , completion : @escaping (Bool ,AnyObject? ,NSError?) -> Void){
        AlamofireSubclass.parseLinkUsingPostMethod(servicename, with: parameters) { (success, response, error) in
            if success == true {
                if response != nil {
                    //OYUser.currentUser.count = response as! NSDictionary
                    completion(true,response,nil)
                }
                else {
                    print(error!)
                }
            }
            else {
                
            }
        }
    }
    //MARK:- JHUD
    static  func showJHud(target: UIViewController) -> JHUD {
         var hudView : JHUD!
        hudView = JHUD(frame: target.view.bounds)
        hudView.messageLabel.text = ""
        hudView.indicatorBackGroundColor = UIColor.darkGray.withAlphaComponent(0.1)
        hudView.indicatorForegroundColor = UIColor.lightGray
        hudView.show(at: target.view, hudType: JHUDLoadingType.circle)
        return hudView
    }
    static  func hideJHud(hudView : JHUD){
        hudView.hide()
    }

   
    
//    //MARK:- Set Up Navigation
//    static func setUpNavigationBar(targetVC : UIViewController,title : String) {
//        targetVC.navigationController?.navigationBar.barTintColor = UIColor(red: 67/255, green: 140/255, blue: 255/255, alpha: 1.0)
//        targetVC.navigationController?.navigationBar.backgroundColor = UIColor(red: 67/255, green: 140/255, blue: 255/255, alpha: 1.0)
//        
//        targetVC.navigationItem.title = title
//        
//        targetVC.navigationController?.navigationBar.titleTextAttributes =  [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont(name: "Arimo-Regular", size: 18)!]
//    }
}

