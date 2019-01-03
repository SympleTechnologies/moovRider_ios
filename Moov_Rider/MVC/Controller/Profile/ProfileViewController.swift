//
//  ProfileViewController.swift
//  Moov_Rider
//
//  Created by Munachimso Ugorji on 02/01/2019.
//  Copyright © 2019 Visakh. All rights reserved.
//

import UIKit
import SDWebImage
import Photos

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: CircleImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileLocationLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var institutionTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var imageSelectButton: UIButton!

    var imagePicker = UIImagePickerController()
    var imageChosen : UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        viewDetails()
        self.profileNameLabel.text = User.current.user_details?.u_first_name
        let imageUrl = User.current.user_pic_url!
        self.profileImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "dummy") , options: SDWebImageOptions.highPriority) { (image, error, cache, url) in
        }
    }

    func setUpView() {

        let btnMenu = UIButton(type: .custom)
        btnMenu.setImage(#imageLiteral(resourceName: "Back_Button_3x"), for: .normal)
        btnMenu.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        btnMenu.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        let item3 = UIBarButtonItem(customView: btnMenu)
        self.navigationItem.setLeftBarButton(item3, animated: true)

        self.navigationItem.title = "Profile"
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.red]
        navigationController?.navigationBar.titleTextAttributes = textAttributes

        let btn1 = UIButton(type: .custom)
        btn1.setBackgroundImage(#imageLiteral(resourceName: "wallet"), for: .normal)
        btn1.imageView?.contentMode = .scaleAspectFit
        btn1.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        btn1.addTarget(self, action: #selector(notificationAction), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: btn1)

        let btn2 = UIButton(type: .custom)
        btn2.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        btn2.addTarget(self, action: #selector(notificationAction), for: .touchUpInside)
        let item2 = UIBarButtonItem(customView: btn2)

        self.navigationItem.setRightBarButtonItems([item1,item2], animated: true)
    }

    func viewDetails() {
        let hud = GenericFunctions.showJHud(target: self)
        AlamofireSubclass.parseLinkUsingGetMethod("view/details/user/\(User.current.user_details!.u_id!)") { (success, response, error) in
            hud.hide()
            if success == true {
                if response!["message"] as! String == "User detais" {
                    let data = response!["data"]as! NSDictionary
                    let userDetails = data["user_details"] as! NSDictionary
                    self.profileNameLabel.text = (userDetails["first_name"] as!  String) + (userDetails["last_name"] as!  String)
                    self.nameTextField.text = (userDetails["first_name"] as!  String) + (userDetails["last_name"] as!  String)
                    self.emailTextField.text = (userDetails["email"] as!  String)
                    self.institutionTextField.text = (userDetails["institution_name"] as!  String)
//                    let phoneNum = userDetails["phone"] as!  String
//                    let countryCode = userDetails["phone_country"] as! String
//                    self.textFieldPhoneNumber.text = "\(countryCode)\(phoneNum)"
//                    self.collegeID = userDetails["institution_id"] as! Int
                    let imageUrl = data["user_pic_url"] as! String
                    self.profileImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "dummy") , options: SDWebImageOptions.highPriority) { (image, error, cache, url) in
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

    func uploadProfilePicture()  {
        var params  : NSDictionary?
        params = ["userid": String(User.current.user_details!.u_id)]
        let hud = GenericFunctions.showJHud(target: self)
        AlamofireSubclass.parseLinkUsingPostMethod("update/profile_pic", with: params!, imagedata: UIImageJPEGRepresentation(imageChosen!, 5.0)!, imageKey: "image") { (success, response, error) in
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

    @objc func backButtonAction() {
        //self.navigationController?.popViewController(animated: true)
        menuContainerViewController.toggleLeftSideMenuCompletion(nil)
    }

    @objc func notificationAction() {
        let walletVc = self.storyboard?.instantiateViewController(withIdentifier: "MyWalletViewController") as! MyWalletViewController
        self.navigationController?.pushViewController(walletVc, animated: true)
    }

    @IBAction func imageSelectAction(_ sender: UIButton) {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = false
        imagePicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        self.present(imagePicker, animated: true, completion: nil)
    }

}

extension ProfileViewController: UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let tempImage:UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.profileImageView.image = tempImage
        if let imageURL = info[UIImagePickerControllerReferenceURL] as? URL {
            let result = PHAsset.fetchAssets(withALAssetURLs: [imageURL], options: nil)
            let asset = result.firstObject
        }
        self.imageChosen = tempImage
        if imageChosen != nil{
            self.uploadProfilePicture()
        }else{
            GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Please select a image")
        }
        dismiss(animated: true, completion: nil)
    }

}
