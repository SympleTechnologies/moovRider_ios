//
//  TalkToUsTableViewController.swift
//  Moov_Rider
//
//  Created by Visakh on 10/09/18.
//  Copyright © 2018 Visakh. All rights reserved.
//

import UIKit

class TalkToUsTableViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var viewMessage                          : UIView!
    @IBOutlet weak var buttonSend                           : UIButton!
    @IBOutlet weak var textFiledMessage                     : UITextField!
    @IBOutlet weak var viewFullname                         : UIView!
    @IBOutlet weak var textFiledFullName                    : UITextField!
    var activeTextField                                     : UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(keyboardHide))
        self.view.addGestureRecognizer(tapGesture)
        
    }
    
    func setupUI()  {
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 10, width: self.view.frame.width, height: 50.0)
        let btn1 = UIButton(type: .custom)
        btn1.setBackgroundImage(#imageLiteral(resourceName: "wallet"), for: .normal)
        btn1.imageView?.contentMode = .scaleAspectFit
        //btn1.setImage(UIImage(named: "Notification_button_3x"), for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        btn1.addTarget(self, action: #selector(notificationAction), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: btn1)
        
        let btn2 = UIButton(type: .custom)
        
        // btn2.setImage(UIImage(named: "Notification_button_3x"), for: .normal)
        btn2.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        btn2.addTarget(self, action: #selector(notificationAction), for: .touchUpInside)
        let item2 = UIBarButtonItem(customView: btn2)
        
        self.navigationItem.setRightBarButtonItems([item1,item2], animated: true)
        let btnMenu = UIButton(type: .custom)
        btnMenu.setImage(#imageLiteral(resourceName: "Back_Button_3x"), for: .normal)
        btnMenu.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        btnMenu.addTarget(self, action: #selector(sideMenuAction), for: .touchUpInside)
        let item3 = UIBarButtonItem(customView: btnMenu)
        self.navigationItem.setLeftBarButton(item3, animated: true)
        
        /*let logo = UIImage(named: "Let’s moov!")
         let imageViewLogo = UIImageView(image:logo)
         self.navigationItem.titleView = imageViewLogo*/
        self.navigationItem.title = "TALK TO US"
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.red]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        
        buttonSend.layer.cornerRadius = 10.0
        buttonSend.layer.masksToBounds = true
        
        textFiledFullName.leftViewMode = .always
        let imageView = UIImageView(frame:CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.image = #imageLiteral(resourceName: "mail_3x")
        let paddingView = UIView(frame:CGRect(x: 0, y: 0, width: 40, height: textFiledFullName.frame.height))
        let paddingViewV = UIView(frame:CGRect(x: 0, y: 0, width: 40, height: textFiledFullName.frame.height))
        imageView.center = paddingView.center
        paddingView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        paddingViewV.addSubview(paddingView)
        paddingViewV.backgroundColor = UIColor.clear
        textFiledFullName.leftView = paddingViewV
        
        
        textFiledMessage.leftViewMode = .always
         let imageView1 = UIImageView(frame:CGRect(x: 0, y: 0, width: 30, height: 30))
         imageView1.image = #imageLiteral(resourceName: "mail_3x")
         let paddingView1 = UIView(frame:CGRect(x: 0, y: 0, width: 40, height: textFiledMessage.frame.height))
         let paddingViewW = UIView(frame:CGRect(x: 0, y: 0, width: 40, height: textFiledMessage.frame.height))
         imageView1.center = paddingView1.center
         paddingView1.addSubview(imageView1)
         imageView1.contentMode = .scaleAspectFit
         paddingViewW.addSubview(paddingView1)
         paddingViewW.backgroundColor = UIColor.clear
         textFiledMessage.leftView = paddingViewW
        
        viewFullname.layer.borderColor = UIColor.lightGray.cgColor
        viewFullname.layer.borderWidth = 1.0
        viewFullname.layer.masksToBounds = true
        
        viewMessage.layer.borderColor = UIColor.lightGray.cgColor
        viewMessage.layer.borderWidth = 1.0
        viewMessage.layer.masksToBounds = true
        
        //View top rounded border
        viewFullname.clipsToBounds          = true
        viewFullname.layer.cornerRadius     = 15
        if #available(iOS 11.0, *) {
            viewFullname.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        }else {
            // Fallback on earlier versions
        }
        //View botton rounded border
        viewMessage.clipsToBounds      = true
        viewMessage.layer.cornerRadius = 15
        if #available(iOS 11.0, *) {
            viewMessage.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        }else {
            // Fallback on earlier versions
        }
        
    }
    
    @objc func notificationAction() {
        
        let walletVc = self.storyboard?.instantiateViewController(withIdentifier: "MyWalletViewController") as! MyWalletViewController
        self.navigationController?.pushViewController(walletVc, animated: true)
    }
    //MARK:- Toggle SideMenu
    @objc func sideMenuAction() {
        menuContainerViewController.toggleLeftSideMenuCompletion(nil)
    }

    //MARK: API Talk To Us
    func talkToUs()  {
        let hud = GenericFunctions.showJHud(target: self)
        AlamofireSubclass.parseLinkUsingPostMethod("support/email", with: ["userid":String(User.current.user_details!.u_id),"from":"","subject": textFiledFullName.text!,"message": textFiledMessage.text!]) { (success, response, error) in
            hud.hide()
            if success  == true {
                if response!["message"] as! String == "Support sent successfully"
                {
                    GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Success")
                    
                }else {
                    GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Please try again")
                }
            }else{
                GenericFunctions.showAlertView(targetVC: self, title: "Message", message: (error?.localizedDescription)!)
            }
        }
    }
    
    @IBAction func buttonSendAction(_ sender: UIButton) {
        if textFiledFullName.text?.isEmpty == false {
            if textFiledMessage.text?.isEmpty == false {
                self.talkToUs()
            }else {
                GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Please fill the fields")
            }
        }else {
            GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Please fill the fields")
        }
    }
    
    @objc func keyboardHide()  {
        textFiledMessage.resignFirstResponder()
        textFiledFullName.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFiledMessage.resignFirstResponder()
        textFiledFullName.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
