//
//  SelectPreferredRoleViewController.swift
//  Moov_Rider
//
//  Created by Henry Chukwu on 12/5/18.
//  Copyright © 2018 Visakh. All rights reserved.
//

import UIKit

class SelectPreferredRoleViewController: UIViewController, NIDropDownDelegate {

    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var textFieldRole: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var topView: BorderView!

    var firstName: String!
    var surName: String!
    var emailID: String!
    var password: String!
    var imageData: Data!
    var authMode: String!
    var authProvider: String!
    var authUID: String!
    var imageUrl: String!
    var arrayCollegeList: [College]!
    var arrayUserRole: [UserType]!
    var arrayCollegeNameList: NSMutableArray!
    var arrayDropDwnUserRole: NSMutableArray!

    var isDropDownOpen = Bool()
    var nidropDown = NIDropDown()
    var collegeID: Int!
    var userRoleID: Int!

    var arrayPlaces = NSMutableArray()
    var arrayPlacesName = NSMutableArray()
    var dropdown: BMGooglePlaces!
    var activeTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        continueButton.layer.cornerRadius = 25.0
        continueButton.layer.masksToBounds = true
        signUpButton.layer.cornerRadius = 25.0
        signUpButton.layer.masksToBounds = true
        topView.shouldDrawBottomBorder = true
        nidropDown.delegate = self
        listUserRole()
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

    @IBAction func buttonSelectRoleAction(_ sender: UIButton) {
        sender.isSelected   = !sender.isSelected
//        selectUniversity = false
        if isDropDownOpen == true {
            nidropDown.hide(sender)
//            if previousDropBtn != sender {
//                previousDropBtn.isSelected = !previousDropBtn.isSelected
//            }
            isDropDownOpen = false
        }
        if sender.isSelected == true {
            nidropDown.show(sender,120.0, arrayDropDwnUserRole as! [Any], nil, "down")
            //(sender, 120.0 , , nil, "down")
            isDropDownOpen = true
        }else {
            nidropDown.hide(sender)
        }
//        previousDropBtn = sender

    }

    @IBAction func buttonNextAction(_ sender: UIButton) {

        if textFieldRole.text?.isEmpty == false{
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

        } else {
            GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Please select university")
        }


    }

    func niDropDownDelegateMethod(_ sender: UIButton!, selectedIndex index: Int32) {
        userRoleID = arrayUserRole[Int(index)].id
        self.textFieldRole.text = (arrayDropDwnUserRole[Int(index)] as! String)
        nidropDown.hide(sender)
        nidropDown.removeFromSuperview()
    }

}
