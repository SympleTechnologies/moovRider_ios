//
//  SelectPreferredInstitutionViewController.swift
//  Moov_Rider
//
//  Created by Visakh on 17/07/18.
//  Copyright © 2018 Visakh. All rights reserved.
//

import UIKit
import GooglePlaces


class SelectPreferredInstitutionViewController: UIViewController, NIDropDownDelegate {
    
    @IBOutlet weak var textFiledRole    : UITextField!
    @IBOutlet weak var buttonNext       : UIButton!
    @IBOutlet weak var textFieldUniv    : UITextField!
    
    var firstName                       : String!
    var surName                         : String!
    var emailID                         : String!
    var password                        : String!
    var imageData                       : Data!
    var authMode                        : String!
    var authProvider                    : String!
    var authUID                         : String!
    var imageUrl                        : String!
    var previousDropBtn                 : UIButton!
    var newDropBtn                      : UIButton!
    var arrayCollegeList                : [College]!
    var arrayUserRole                   : [UserType]!
    var arrayCollegeNameList            : NSMutableArray!
    var arrayDropDwnUserRole            : NSMutableArray!
    
    var isDropDownOpen                  = Bool()
    var nidropDown                      = NIDropDown()
    var selectUniversity                = Bool()
    var collegeID                       : Int!
    var userRoleID                      : Int!
    
    var arrayPlaces                     = NSMutableArray()
    var arrayPlacesName                 = NSMutableArray()
    var dropdown                        : BMGooglePlaces!
    var activeTextField                 : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nidropDown.delegate = self
        self.setupUI()
        self.listColleges()
        self.listUserRole()
    }
    
    func setupUI()  {
        selectUniversity = false
        textFieldUniv.leftViewMode = .always
        let imageView = UIImageView(frame:CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.image = #imageLiteral(resourceName: "mail_3x")
        let paddingView = UIView(frame:CGRect(x: 0, y: 0, width: 40, height: textFieldUniv.frame.height))
        let paddingViewV = UIView(frame:CGRect(x: 0, y: 0, width: 40, height: textFieldUniv.frame.height))
        imageView.center = paddingView.center
        paddingView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        paddingViewV.addSubview(paddingView)
        paddingViewV.backgroundColor = UIColor.clear
        textFieldUniv.leftView = paddingViewV
        
        textFiledRole.leftViewMode = .always
        let imageView1 = UIImageView(frame:CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView1.image = #imageLiteral(resourceName: "mail_3x")
        let paddingView1 = UIView(frame:CGRect(x: 0, y: 0, width: 40, height: textFiledRole.frame.height))
        let paddingViewW = UIView(frame:CGRect(x: 0, y: 0, width: 40, height: textFiledRole.frame.height))
        imageView1.center = paddingView1.center
        paddingView1.addSubview(imageView1)
        imageView1.contentMode = .scaleAspectFit
        paddingViewW.addSubview(paddingView1)
        paddingViewW.backgroundColor = UIColor.clear
        textFiledRole.leftView = paddingViewW
        
        self.buttonNext.layer.cornerRadius = 10.0
        self.textFieldUniv.layer.borderColor = UIColor.lightGray.cgColor
        self.textFieldUniv.layer.borderWidth =  1.0
        
        self.textFiledRole.layer.borderColor = UIColor.lightGray.cgColor
        self.textFiledRole.layer.borderWidth =  1.0
        
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 10, width: self.view.frame.width, height: 50.0)
        let btnMenu = UIButton(type: .custom)
        btnMenu.setImage(#imageLiteral(resourceName: "Back_Button_3x"), for: .normal)
        btnMenu.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        btnMenu.addTarget(self, action: #selector(sideMenuAction), for: .touchUpInside)
        let item3 = UIBarButtonItem(customView: btnMenu)
        self.navigationItem.setLeftBarButton(item3, animated: true)
        
        /*let logo = UIImage(named: "Let’s moov!")
         let imageViewLogo = UIImageView(image:logo)
         self.navigationItem.titleView = imageViewLogo*/
        self.navigationItem.title = "Moov"
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.red]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        
    }
    
    //MARK: Api List Colleges
    func listColleges() {
        let hud = GenericFunctions.showJHud(target: self)
        AlamofireSubclass.parseLinkUsingGetMethod("auth/select_college") { (success, response, error) in
            hud.hide()
            if success == true {
                self.arrayCollegeList = [College]()
                self.arrayCollegeNameList = NSMutableArray()
                if response!["message"] as! String == "College List" {
                    let dataDict = response!["data"] as! NSDictionary
                    for dict in dataDict["details"] as! NSArray {
                        let objClg = College().initWith((dict as! NSDictionary))
                        self.arrayCollegeList.append(objClg)
                        self.arrayCollegeNameList.add(objClg.name)
                    }
                }else {
                    GenericFunctions.showAlertView(targetVC: self, title: "Error", message: "Please try again")
                }
                
            }else{
                GenericFunctions.showAlertView(targetVC: self, title: "Error", message: (error?.localizedDescription)!)
            }
        }
    }
    
    //MARK: Api List UserRole
    func listUserRole() {
        let hud = GenericFunctions.showJHud(target: self)
        AlamofireSubclass.parseLinkUsingGetMethod("auth/select_user_type") { (success, response, error) in
            hud.hide()
            if success == true {
                self.arrayUserRole = [UserType]()
                self.arrayDropDwnUserRole = NSMutableArray()
                if response!["message"] as! String == "User type List" {
                    let dataDict = response!["data"] as! NSDictionary
                    for dict in dataDict["details"] as! NSArray {
                        let objUser = UserType().initWith((dict as! NSDictionary))
                        self.arrayUserRole.append(objUser)
                        self.arrayDropDwnUserRole.add(objUser.role)
                    }
                }else {
                    GenericFunctions.showAlertView(targetVC: self, title: "Error", message: "Please try again")
                }
            }else{
                GenericFunctions.showAlertView(targetVC: self, title: "Error", message: (error?.localizedDescription)!)
            }
        }
    }
    
    
    
    //MARK:- Button Actions
    @IBAction func SelectPreferredInstitutionDropDownAction(_ sender: UIButton) {
        sender.isSelected   = !sender.isSelected
        selectUniversity = true
        if isDropDownOpen == true {
            nidropDown.hide(previousDropBtn)
            if previousDropBtn != sender {
                previousDropBtn.isSelected = !previousDropBtn.isSelected
            }
            isDropDownOpen = false
        }
        if sender.isSelected == true {
            nidropDown.show(sender,120.0, arrayCollegeNameList as! [Any], nil, "down")
            //(sender, 120.0 , , nil, "down")
            isDropDownOpen = true
        }else {
            nidropDown.hide(sender)
        }
        previousDropBtn = sender
    }
    
    @IBAction func buttonSelectRoleAction(_ sender: UIButton) {
        sender.isSelected   = !sender.isSelected
        selectUniversity = false
        if isDropDownOpen == true {
            nidropDown.hide(previousDropBtn)
            if previousDropBtn != sender {
                previousDropBtn.isSelected = !previousDropBtn.isSelected
            }
            isDropDownOpen = false
        }
        if sender.isSelected == true {
            nidropDown.show(sender,120.0, arrayDropDwnUserRole as! [Any], nil, "down")
            //(sender, 120.0 , , nil, "down")
            isDropDownOpen = true
        }else {
            nidropDown.hide(sender)
        }
        previousDropBtn = sender
        
    }
    
    @IBAction func buttonNextAction(_ sender: UIButton) {
        
        if textFieldUniv.text?.isEmpty == false{
            if textFiledRole.text?.isEmpty == false{
                let enterPhoneNumberVC = self.storyboard?.instantiateViewController(withIdentifier: "EnterMobileNumberViewController") as! EnterMobileNumberViewController
                enterPhoneNumberVC.firstname = self.firstName!
                enterPhoneNumberVC.surName = self.surName!
                enterPhoneNumberVC.emailID = self.emailID!
                enterPhoneNumberVC.password = self.password!
                enterPhoneNumberVC.collegeID = self.collegeID!
                enterPhoneNumberVC.userRoleID = self.userRoleID!
                enterPhoneNumberVC.authMode = self.authMode!
                enterPhoneNumberVC.authProvider = self.authProvider!
                enterPhoneNumberVC.imageData = self.imageData!
                enterPhoneNumberVC.authUID = self.authUID!
                enterPhoneNumberVC.imageUrl = self.imageUrl!
                self.navigationController?.pushViewController(enterPhoneNumberVC, animated: true)
                
            }else{
                GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Please select role")
            }
        }else{
            GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Please select university")
        }
        
       
    }
    
    //MARK:- Dropdown delegate
    func niDropDownDelegateMethod(_ sender: UIButton!, selectedIndex index: Int32) {
        
        if selectUniversity == true {
            collegeID = arrayCollegeList[Int(index)].id
            self.textFieldUniv.text = (arrayCollegeNameList[Int(index)] as! String)
        }else{
            userRoleID = arrayUserRole[Int(index)].id
            self.textFiledRole.text = (arrayDropDwnUserRole[Int(index)] as! String)
        }
        nidropDown.hide(previousDropBtn)
        nidropDown.removeFromSuperview()
    }
    @objc func sideMenuAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
}
