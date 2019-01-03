//
//  SideMenuTableViewController.swift
//  Moov_Rider
//
//  Created by Visakh on 17/07/18.
//  Copyright © 2018 Visakh. All rights reserved.
//

import UIKit
import SDWebImage

class SideMenuTableViewController: UITableViewController, NIDropDownDelegate {
    
    
    @IBOutlet weak var imageViewProfile                 : UIImageView!
    @IBOutlet weak var buttonProfileImage               : UIButton!
    @IBOutlet weak var labelusername                    : UILabel!
    @IBOutlet weak var labelRides                       : UILabel!
    var arrHeights                                      = [200.0,30.0,45.0,45.0,45.0,45.0,45.0,45.0,45.0,45.0]
    var previousDropBtn                                 : UIButton!
    var isDropDownOpen                                  = Bool()
    var nidropDown                                      = NIDropDown()
    var dropdownArr                                     = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
//        buttonProfileImage.layer.cornerRadius = 75.0
//        buttonProfileImage.layer.masksToBounds = true
//        imageViewProfile.layer.cornerRadius = 75.0
//        imageViewProfile.layer.masksToBounds = true
//        imageViewProfile.layer.borderColor = UIColor.red.cgColor
//        imageViewProfile.layer.borderWidth = 1.5
//
//        imageViewProfile.layer.shadowRadius = 10
//        imageViewProfile.layer.shadowOpacity = 0.8
//        imageViewProfile.layer.shadowColor = UIColor.black.cgColor
//        imageViewProfile.layer.shadowOffset = CGSize.zero
//
//
//        imageViewProfile.generateOuterShadow()
//
        self.viewDetails()
        dropdownArr = ["Upcoming Rides","Previous Rides"]
        nidropDown.delegate = self
        self.labelusername.text = User.current.user_details?.u_first_name!
        let imageUrl = User.current.user_pic_url!
        self.imageViewProfile.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "dummy") , options: SDWebImageOptions.highPriority) { (image, error, cache, url) in
            //
        }
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name(rawValue: "updateProfile"), object: nil)
        
        
        
        
        let Image = User.current.user_pic_url!
        if Image != "" {
            if let thumb = SDWebImageManager.shared().imageCache?.imageFromCache(forKey: Image)
            {
                self.imageViewProfile.sd_setImage(with:  URL(string: Image), placeholderImage: thumb, options: .highPriority, completed: {(imageOg, error, cache, url) in
                })
            }
            else
            {
                self.imageViewProfile.sd_setImage(with: URL(string: Image)!, placeholderImage: #imageLiteral(resourceName: "dummy"), options: .highPriority, completed: { (image, error, cache, url) in
                    if image != nil{
                        DispatchQueue.main.async {
                            self.imageViewProfile.sd_setImage(with:  URL(string: Image), completed: { (imageOg, error, cache, url) in
                                //
                            })
                        }
                    }
                })
            }
        }
        else {
            self.imageViewProfile.image = #imageLiteral(resourceName: "dummy")
        }
    }
    //MARK:- View Details
    func viewDetails() {
        let hud = GenericFunctions.showJHud(target: self)
        AlamofireSubclass.parseLinkUsingGetMethod("view/details/user/\(User.current.user_details!.u_id!)") { (success, response, error) in
            hud.hide()
            if success == true {
                if response!["message"] as! String == "User detais" {
                    let data = response!["data"]as! NSDictionary
                    let userDetails = data["user_details"] as! NSDictionary
                    self.labelusername.text = (userDetails["first_name"] as!  String)
                    let imageUrl = data["user_pic_url"] as! String
                    self.imageViewProfile.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "dummy") , options: SDWebImageOptions.highPriority) { (image, error, cache, url) in
                        //
                    }
                }else{
                    GenericFunctions.showAlertView(targetVC: self, title: "Error", message: "")
                }
            }else{
                GenericFunctions.showAlertView(targetVC: self, title: "Error", message: (error?.localizedDescription)!)
            }
        }
    }
    //MARK:- Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let editProfileVC    = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            let navVC         = UINavigationController(rootViewController: editProfileVC)
            menuContainerViewController.centerViewController = navVC
            self.menuContainerViewController.menuState = MFSideMenuStateClosed
        }
        else if indexPath.row == 1
        {
            
        }else if indexPath.row == 2 {
            
            let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "EnterDestinationViewController") as! EnterDestinationViewController
            let navVC = UINavigationController(rootViewController: homeVC)
            menuContainerViewController.centerViewController = navVC
            self.menuContainerViewController.menuState = MFSideMenuStateClosed
        }else if indexPath.row == 3 {
            
        }else if indexPath.row == 4 {
            let paymentVC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentListViewController") as! PaymentListViewController
            let navVC = UINavigationController(rootViewController: paymentVC)
            paymentVC.pageID = "Payment"
            menuContainerViewController.centerViewController = navVC
            self.menuContainerViewController.menuState = MFSideMenuStateClosed
        }else if indexPath.row == 5 {
            let talkToUs = self.storyboard?.instantiateViewController(withIdentifier: "TalkToUsTableViewController") as! TalkToUsTableViewController
            let navVC = UINavigationController(rootViewController: talkToUs)
            menuContainerViewController.centerViewController = navVC
            self.menuContainerViewController.menuState = MFSideMenuStateClosed
        }else if indexPath.row == 6 {
            let settingsVC = self.storyboard?.instantiateViewController(withIdentifier: "ResetDetailsViewController") as! ResetDetailsViewController
            let navVC = UINavigationController(rootViewController: settingsVC)
            menuContainerViewController.centerViewController = navVC
            self.menuContainerViewController.menuState = MFSideMenuStateClosed
        }else if indexPath.row == 7 {
            /*let alert = UIAlertController(title: "Message", message: "Do you want to logout.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction((UIAlertAction(title: "OK", style: .destructive, handler: {(action) -> Void in
                DispatchQueue.main.async {
                    User.logOutCurrentUser()
                    let LoginTableVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginTableViewController") as! LoginTableViewController
                    (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = LoginTableVC
                }
            })))
            alert.addAction((UIAlertAction(title: "Cancel", style: .destructive, handler: {(action) -> Void in
            })))
            self.present(alert, animated: true, completion: nil)*/
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(arrHeights[indexPath.row])
    }
    //MARK:- Dropdown delegate
    func niDropDownDelegateMethod(_ sender: UIButton!, selectedIndex index: Int32) {
        self.labelRides.text = (dropdownArr[Int(index)] as! String)
        nidropDown.hide(previousDropBtn)
        nidropDown.removeFromSuperview()
        tableView.beginUpdates()
        arrHeights[3] = 45.0
        tableView.endUpdates()
        if index == 0 {
            let homePage = self.storyboard?.instantiateViewController(withIdentifier: "PreviousRidesViewController")
                as! PreviousRidesViewController
            let navVC = UINavigationController(rootViewController: homePage)
            let sideVC = self.storyboard?.instantiateViewController(withIdentifier: "SideMenuTableViewController") as! SideMenuTableViewController
            let mfContainer = MFSideMenuContainerViewController.container(withCenter: navVC, leftMenuViewController: sideVC, rightMenuViewController: nil)
            UIApplication.shared.keyWindow?.rootViewController = mfContainer
        }else {
            let homePage = self.storyboard?.instantiateViewController(withIdentifier: "PaymentListViewController")
                as! PaymentListViewController
            homePage.pageID = "PreviousRides"
            let navVC = UINavigationController(rootViewController: homePage)
            let sideVC = self.storyboard?.instantiateViewController(withIdentifier: "SideMenuTableViewController") as! SideMenuTableViewController
            let mfContainer = MFSideMenuContainerViewController.container(withCenter: navVC, leftMenuViewController: sideVC, rightMenuViewController: nil)
            UIApplication.shared.keyWindow?.rootViewController = mfContainer
        }
    }
    //MARK:- Button Actions
    @IBAction func btnRidesTouched(_ sender: UIButton) {
        sender.isSelected   = !sender.isSelected
        if isDropDownOpen == true {
            nidropDown.hide(previousDropBtn)
            if previousDropBtn != sender {
                previousDropBtn.isSelected = !previousDropBtn.isSelected
            }
            isDropDownOpen = false
        }
        if sender.isSelected == true {
            nidropDown.show(sender,80.0, dropdownArr as! [Any], nil, "down")
            tableView.beginUpdates()
            arrHeights[3] = 130
            tableView.endUpdates()
            //(sender, 120.0 , , nil, "down")
            isDropDownOpen = true
        }else {
            nidropDown.hide(sender)
            tableView.beginUpdates()
            arrHeights[3] = 45.0
            tableView.endUpdates()
        }
        previousDropBtn = sender
    }
    @IBAction func buttonProfile(_ sender: UIButton) {
        let editProfileVC    = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileTableViewController") as! EditProfileTableViewController
        let navVC         = UINavigationController(rootViewController: editProfileVC)
        menuContainerViewController.centerViewController = navVC
        self.menuContainerViewController.menuState = MFSideMenuStateClosed
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK :- Notification Start Ride
    @objc func reload(){
        let Image = User.current.user_pic_url!
        if Image != "" {
            if let thumb = SDWebImageManager.shared().imageCache?.imageFromCache(forKey: Image)
            {
                self.imageViewProfile.sd_setImage(with:  URL(string: Image), placeholderImage: thumb, options: .highPriority, completed: {(imageOg, error, cache, url) in
                })
            }
            else
            {
                self.imageViewProfile.sd_setImage(with: URL(string: Image)!, placeholderImage: #imageLiteral(resourceName: "dummy"), options: .highPriority, completed: { (image, error, cache, url) in
                    if image != nil{
                        DispatchQueue.main.async {
                            self.imageViewProfile.sd_setImage(with:  URL(string: Image), completed: { (imageOg, error, cache, url) in
                                //
                            })
                        }
                    }
                })
            }
        }
        else {
            self.imageViewProfile.image = #imageLiteral(resourceName: "dummy")
        }
    }
    
}
