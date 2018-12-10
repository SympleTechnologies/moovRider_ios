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
    
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var textFieldUniv: UITextField!
    @IBOutlet weak var cardView: CardView!
    @IBOutlet weak var dropBtn: UIButton!

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

    var arrayPlaces = NSMutableArray()
    var arrayPlacesName = NSMutableArray()
    var dropdown: BMGooglePlaces!
    var activeTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        nidropDown.delegate = self
        continueButton.layer.cornerRadius = 25.0
        continueButton.layer.masksToBounds = true
        self.navigationItem.title = "Sign up"
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.red]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.listColleges()
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
    
    //MARK:- Button Actions
    @IBAction func SelectPreferredInstitutionDropDownAction(_ sender: UIButton) {
        if isDropDownOpen == true {
            nidropDown.hide(sender)
            isDropDownOpen = false
        } else {
            nidropDown.show(sender,150.0, arrayCollegeNameList as! [Any], nil, "down")
            //(sender, 120.0 , , nil, "down")
            isDropDownOpen = true
            nidropDown.isUserInteractionEnabled = true
        }
    }

    @IBAction func buttonNextAction(_ sender: UIButton) {
        
        if textFieldUniv.text?.isEmpty == false{
                let selectPreferredRoleVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectPreferredRoleViewController") as! SelectPreferredRoleViewController
            selectPreferredRoleVC.firstName = self.firstName!
                selectPreferredRoleVC.surName = self.surName!
                selectPreferredRoleVC.emailID = self.emailID!
                selectPreferredRoleVC.password = self.password!
                selectPreferredRoleVC.collegeID = self.collegeID!
                selectPreferredRoleVC.authMode = self.authMode!
                selectPreferredRoleVC.authProvider = self.authProvider!
                selectPreferredRoleVC.imageData = self.imageData!
                selectPreferredRoleVC.authUID = self.authUID!
                selectPreferredRoleVC.imageUrl = self.imageUrl!
                self.navigationController?.pushViewController(selectPreferredRoleVC, animated: true)

        } else {
            GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Please select university")
        }
        
       
    }
    
    //MARK:- Dropdown delegate
    func niDropDownDelegateMethod(_ sender: UIButton!, selectedIndex index: Int32) {
        collegeID = arrayCollegeList[Int(index)].id
        self.textFieldUniv.text = (arrayCollegeNameList[Int(index)] as! String)
        nidropDown.hide(sender)
        nidropDown.removeFromSuperview()
    }


    @objc func sideMenuAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
}
