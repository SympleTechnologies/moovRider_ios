//
//  EditProfileTableViewController.swift
//  Moov_Rider
//
//  Created by Visakh on 17/07/18.
//  Copyright © 2018 Visakh. All rights reserved.
//

import UIKit
import Photos
import SDWebImage

class EditProfileTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, NIDropDownDelegate, UIPickerViewDataSource, UIPickerViewDelegate  {

    @IBOutlet weak var buttonSelectProfilePicture               : UIButton!
    @IBOutlet weak var buttonDropDown                           : UIButton!
    @IBOutlet weak var imageViewProfile                         : UIImageView!
    @IBOutlet weak var buttonProfile                            : UIButton!
    @IBOutlet weak var buttonSubmit                             : UIButton!
    @IBOutlet weak var labelName                                : UILabel!
    @IBOutlet weak var textFieldFirstName                       : UITextField!
    @IBOutlet weak var textFieldSurName                         : UITextField!
    @IBOutlet weak var textFieldEmail                           : UITextField!
    @IBOutlet weak var textFieldUniversity                      : UITextField!
    @IBOutlet weak var viewFirstnameTxtFld                      : UIView!
    @IBOutlet weak var textFieldPhoneNumber                     : UITextField!
    @IBOutlet weak var viewSurnameTxtFld                        : UIView!
    @IBOutlet weak var viewEmailTxtFld                          : UIView!
    @IBOutlet weak var viewUniversityTxtFld                     : UIView!
    @IBOutlet weak var viewPhoneNumberTxtFld                    : UIView!
    
    var arrHeights                                              = [200.0,30.0,45.0,45.0,45.0,45.0,45.0,45.0,60.0]
    var previousDropBtn                                         : UIButton!
    var imagePicker                                             = UIImagePickerController()
    var imageChoosed                                            : UIImage?
    var arrayCollegeList                                        : [College]!
    var arrayCollegeNameList                                    : [String]!
    var isDropDownOpen                                          = Bool()
    var nidropDown                                              = NIDropDown()
    var collegeID                                               : Int!
    let picker                                                  = UIPickerView()
    let pickerData                                              = ["11", "12", "13"]

    override func viewDidLoad() {
        super.viewDidLoad()
        buttonSubmit.isHidden = true
        nidropDown.delegate = self
       self.setupUI()
        self.listColleges()
        self.viewDetails()
        //*/imageViewProfile.sd_setImage(with: URL(string: User.current.user_pic_url!), placeholderImage: #imageLiteral(resourceName: "dummy") , options: SDWebImageOptions.highPriority) { (image, error, cache, url) in
            //
        //}
        self.textFieldFirstName.isUserInteractionEnabled = false
        self.textFieldSurName.isUserInteractionEnabled = false
        self.textFieldEmail.isUserInteractionEnabled = false
        self.textFieldPhoneNumber.isUserInteractionEnabled = false
        textFieldUniversity.isUserInteractionEnabled = false
        buttonDropDown.isHidden = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(keyboardHide))
        self.view.addGestureRecognizer(tapGesture)
        
        picker.backgroundColor = UIColor.white
        picker.showsSelectionIndicator = true
        picker.delegate = self
        picker.dataSource = self
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePicker))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textFieldUniversity.inputView = picker
        textFieldUniversity.inputAccessoryView = toolBar
    }
    
    func setupUI()  {
        viewFirstnameTxtFld.layer.borderColor = UIColor.lightGray.cgColor
        viewFirstnameTxtFld.layer.borderWidth = 1.0
        viewFirstnameTxtFld.layer.masksToBounds = true
        viewSurnameTxtFld.layer.borderColor = UIColor.lightGray.cgColor
        viewSurnameTxtFld.layer.borderWidth = 1.0
        viewSurnameTxtFld.layer.masksToBounds = true
        viewEmailTxtFld.layer.borderColor = UIColor.lightGray.cgColor
        viewEmailTxtFld.layer.borderWidth = 1.0
        viewEmailTxtFld.layer.masksToBounds = true
        viewUniversityTxtFld.layer.borderColor = UIColor.lightGray.cgColor
        viewUniversityTxtFld.layer.borderWidth = 1.0
        viewUniversityTxtFld.layer.masksToBounds = true
        viewPhoneNumberTxtFld.layer.borderColor = UIColor.lightGray.cgColor
        viewPhoneNumberTxtFld.layer.borderWidth = 1.0
        viewPhoneNumberTxtFld.layer.masksToBounds = true
       
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
        imageView2.image = #imageLiteral(resourceName: "mail_3x")
        let paddingView2 = UIView(frame:CGRect(x: 0, y: 0, width: 40, height: textFieldEmail.frame.height))
        let paddingViewV2 = UIView(frame:CGRect(x: 0, y: 0, width: 40, height: textFieldEmail.frame.height))
        imageView2.center = paddingView2.center
        paddingView2.addSubview(imageView2)
        imageView2.contentMode = .scaleAspectFit
        paddingViewV2.addSubview(paddingView2)
        paddingViewV2.backgroundColor = UIColor.clear
        textFieldEmail.leftView = paddingViewV2
        
        textFieldUniversity.leftViewMode = .always
        let imageView3 = UIImageView(frame:CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView3.image = #imageLiteral(resourceName: "University")
        imageView3.alpha = 0.5
        
        let paddingView3 = UIView(frame:CGRect(x: 0, y: 0, width: 40, height: textFieldUniversity.frame.height))
        let paddingViewV3 = UIView(frame:CGRect(x: 0, y: 0, width: 40, height: textFieldUniversity.frame.height))
        imageView3.center = paddingView3.center
        paddingView3.addSubview(imageView3)
        imageView3.contentMode = .scaleAspectFit
        paddingViewV3.addSubview(paddingView3)
        paddingViewV3.backgroundColor = UIColor.clear
        textFieldUniversity.leftView = paddingViewV3
        
        textFieldPhoneNumber.leftViewMode = .always
        let imageView4 = UIImageView(frame:CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView4.image = #imageLiteral(resourceName: "phone")
        let paddingView4 = UIView(frame:CGRect(x: 0, y: 0, width: 40, height: textFieldPhoneNumber.frame.height))
        let paddingViewV4 = UIView(frame:CGRect(x: 0, y: 0, width: 40, height: textFieldPhoneNumber.frame.height))
        imageView4.center = paddingView4.center
        paddingView4.addSubview(imageView4)
        imageView4.contentMode = .scaleAspectFit
        paddingViewV4.addSubview(paddingView4)
        paddingViewV4.backgroundColor = UIColor.clear
        textFieldPhoneNumber.leftView = paddingViewV4
        
        buttonSubmit.layer.cornerRadius = 10.0
        buttonSubmit.layer.masksToBounds = true

        buttonProfile.layer.cornerRadius = 75.0
        buttonProfile.layer.masksToBounds = true
        imageViewProfile.layer.cornerRadius = 75.0
        buttonProfile.layer.masksToBounds = true
        buttonProfile.layer.borderColor = UIColor.red.cgColor
        buttonProfile.layer.borderWidth = 1.5
        imageViewProfile.layer.borderColor = UIColor.red.cgColor
        imageViewProfile.layer.borderWidth = 1.5
        
        imageViewProfile.layer.shadowRadius = 10
        imageViewProfile.layer.shadowOpacity = 0.8
        imageViewProfile.layer.shadowColor = UIColor.black.cgColor
        imageViewProfile.layer.shadowOffset = CGSize.zero
        imageViewProfile.generateOuterShadow()
        
        buttonSelectProfilePicture.layer.cornerRadius = 5.0
        buttonSelectProfilePicture.layer.masksToBounds = true
        
        let btnMenu = UIButton(type: .custom)
        btnMenu.setImage(#imageLiteral(resourceName: "Back_Button_3x"), for: .normal)
        btnMenu.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        btnMenu.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        let item3 = UIBarButtonItem(customView: btnMenu)
        self.navigationItem.setLeftBarButton(item3, animated: true)
        
       
        self.navigationItem.title = "Moov"
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.red]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        
        //View top rounded border
        viewFirstnameTxtFld.clipsToBounds          = true
        viewFirstnameTxtFld.layer.cornerRadius     = 15
        if #available(iOS 11.0, *) {
            viewFirstnameTxtFld.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        } else {
            // Fallback on earlier versions
        }
        //View botton rounded border
        viewPhoneNumberTxtFld.clipsToBounds      = true
        viewPhoneNumberTxtFld.layer.cornerRadius = 15
        if #available(iOS 11.0, *) {
            viewPhoneNumberTxtFld.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        } else {
            // Fallback on earlier versions
        }
    }
    
    //MARK: Api List Colleges
    func listColleges() {
        AlamofireSubclass.parseLinkUsingGetMethod("auth/select_college") { (success, response, error) in
            if success == true {
                self.arrayCollegeList = [College]()
                self.arrayCollegeNameList = [String]()
                if response!["message"] as! String == "College List" {
                    let dataDict = response!["data"] as! NSDictionary
                    for dict in dataDict["details"] as! NSArray {
                        let objClg = College().initWith((dict as! NSDictionary))
                        self.arrayCollegeList.append(objClg)
                        self.arrayCollegeNameList.append(objClg.name)
                    }
                }else {
                    GenericFunctions.showAlertView(targetVC: self, title: "Error", message: "Please try again")
                }
            }else{
                GenericFunctions.showAlertView(targetVC: self, title: "Error", message: (error?.localizedDescription)!)
            }
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
                    self.labelName.text = (userDetails["first_name"] as!  String)
                    self.textFieldFirstName.text = (userDetails["first_name"] as!  String)
                    self.textFieldSurName.text = (userDetails["last_name"] as!  String)
                    self.textFieldEmail.text = (userDetails["email"] as!  String)
                    self.textFieldUniversity.text = (userDetails["institution_name"] as!  String)
                    let phoneNum = userDetails["phone"] as!  String
                    let countryCode = userDetails["phone_country"] as! String
                    self.textFieldPhoneNumber.text = "\(countryCode)\(phoneNum)"
                    self.collegeID = userDetails["institution_id"] as! Int
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
    
    //MARK:- API Edit Profile
    func editProfile()  {
        var imgData : Data!
        var params  : NSDictionary?
            params = ["userid":String(User.current.user_details!.u_id!),"f_name":self.textFieldFirstName.text!,"l_name":self.textFieldSurName.text!,"email": self.textFieldEmail.text!,"college": String(collegeID),"phone": self.textFieldPhoneNumber.text!,"gender": ""]
        if imageChoosed != nil{
            imgData = UIImageJPEGRepresentation(imageChoosed!, 5.0)!
        }else{
            imgData = UIImageJPEGRepresentation(imageViewProfile.image!, 5.0)!
        }
        let hud = GenericFunctions.showJHud(target: self)
        AlamofireSubclass.parseLinkUsingPostMethod("update/profile", with: params!, imagedata:imgData, imageKey: "image") { (success, response, error) in
            hud.hide()
            if success == true {
                if response!["message"]as! String == "Updated Successfully" {
                    GenericFunctions.showAlertView(targetVC: self, title: "Success", message: "Succesfully updated your profile")
                }else {
                    GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Please try again")
                }
            }else {
                GenericFunctions.showAlertView(targetVC: self, title: "Message", message: (error?.localizedDescription)!)
            }
        }
    }
    
    //MARK:- Upload Profile Picture
    func uploadProfilePicture()  {
        var params  : NSDictionary?
        params = ["userid": String(User.current.user_details!.u_id)]
        let hud = GenericFunctions.showJHud(target: self)
        AlamofireSubclass.parseLinkUsingPostMethod("update/profile_pic", with: params!, imagedata: UIImageJPEGRepresentation(imageChoosed!, 5.0)!, imageKey: "image") { (success, response, error) in
            hud.hide()
            if success == true {
                if response!["message"]as! String == "Updated Successfully" {
                    let userDict = response!["data"] as! NSDictionary
                    User.current.initWithDictionary(dictionary: userDict)
                    User.saveLoggedUserdetails(dictDetails: userDict)
                     NotificationCenter.default.post(name: Notification.Name("updateProfile"), object: nil, userInfo: nil)
                    GenericFunctions.showAlertView(targetVC: self, title: "Success", message: "Succesfully updated your profile")
                }else {
                    GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Please try again")
                }
            }else {
                
                GenericFunctions.showAlertView(targetVC: self, title: "Message", message: (error?.localizedDescription)!)
            }
        }
    }
    
    //MARK: Button Actions
    @IBAction func buttonEditAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true{
            buttonSubmit.isHidden = false
            self.textFieldFirstName.isUserInteractionEnabled = true
            self.textFieldSurName.isUserInteractionEnabled = true
            textFieldUniversity.isUserInteractionEnabled = true
            buttonDropDown.isHidden = true
        }else{
            buttonSubmit.isHidden = true
            self.textFieldFirstName.isUserInteractionEnabled = false
            self.textFieldSurName.isUserInteractionEnabled = false
            self.textFieldEmail.isUserInteractionEnabled = false
            self.textFieldPhoneNumber.isUserInteractionEnabled = false
            textFieldUniversity.isUserInteractionEnabled = false
            buttonDropDown.isHidden = true
        }
    }
    
    @IBAction func buttonSubmitAction(_ sender: UIButton) {
        if textFieldFirstName.text?.isEmpty == false {
            if textFieldSurName.text?.isEmpty == false {
                if textFieldEmail.text?.isEmpty == false {
                    if textFieldUniversity.text?.isEmpty == false{
                        if textFieldPhoneNumber.text?.isEmpty == false  {
                            self.editProfile()
                            
                        }else{
                            GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Please fill phone number field")
                        }
                    }else{
                        GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Please fill Password field")
                    }
                }else{
                    GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Please fill Email field")
                }
            }else {
                GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Please fill Surname field")
            }
        }else {
            GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Please fill Firstname field")
        }
    }
    
    @IBAction func buttonUploadProfilePicture(_ sender: UIButton) {
        /*if imageChoosed != nil{
            self.uploadProfileProfile()
        }else{
            GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Please choose image")
        }*/
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func buttonSelectUniversity(_ sender: UIButton) {
       /* sender.isSelected   = !sender.isSelected
        if isDropDownOpen == true {
            nidropDown.hide(previousDropBtn)
            if previousDropBtn != sender {
                previousDropBtn.isSelected = !previousDropBtn.isSelected
            }
            isDropDownOpen = false
        }
        if sender.isSelected == true {
            nidropDown.show(sender,230.0, arrayCollegeNameList as! [Any], nil, "down")
            tableView.beginUpdates()
            arrHeights[5] = 230.0
            tableView.endUpdates()
            isDropDownOpen = true
        }else {
            nidropDown.hide(sender)
        }
        previousDropBtn = sender*/
    }
    //MARK:- Pickerview Deleagtes And DataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
   
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayCollegeNameList.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrayCollegeNameList[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textFieldUniversity.text = arrayCollegeNameList[row]
        collegeID = arrayCollegeList[row].id
        textFieldUniversity.resignFirstResponder()
    }
    @objc func donePicker() {
        textFieldUniversity.resignFirstResponder()
    }
    
    
    @IBAction func buttonSelectImageAction(_ sender: UIButton) {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let tempImage:UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.imageViewProfile.image = tempImage
        //self.buttonProfile.setBackgroundImage(tempImage, for: .normal)
        if let imageURL = info[UIImagePickerControllerReferenceURL] as? URL {
            let result = PHAsset.fetchAssets(withALAssetURLs: [imageURL], options: nil)
            let asset = result.firstObject
        }
        self.imageChoosed = tempImage
        if imageChoosed != nil{
            self.uploadProfilePicture()
        }else{
            GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Please select a image")
        }
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Dropdown delegate
    func niDropDownDelegateMethod(_ sender: UIButton!, selectedIndex index: Int32) {
        collegeID = arrayCollegeList[Int(index)].id
        self.textFieldUniversity.text = (arrayCollegeNameList[Int(index)] as! String)
        nidropDown.hide(previousDropBtn)
        nidropDown.removeFromSuperview()
        tableView.beginUpdates()
        arrHeights[5] = 45.0
        tableView.endUpdates()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- Toggle SideMenu
    @objc func backButtonAction() {
        //self.navigationController?.popViewController(animated: true)
        menuContainerViewController.toggleLeftSideMenuCompletion(nil)
    }
    @objc func keyboardHide()  {
        textFieldFirstName.resignFirstResponder()
        textFieldSurName.resignFirstResponder()
        textFieldUniversity.resignFirstResponder()
        textFieldEmail.resignFirstResponder()
        textFieldPhoneNumber.resignFirstResponder()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldFirstName.resignFirstResponder()
        textFieldSurName.resignFirstResponder()
        textFieldUniversity.resignFirstResponder()
        textFieldEmail.resignFirstResponder()
        textFieldPhoneNumber.resignFirstResponder()
        return true
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(arrHeights[indexPath.row])
    }
    

}

