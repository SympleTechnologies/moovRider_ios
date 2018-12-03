//
//  WalletToWalletTableViewController.swift
//  Moov_Rider
//
//  Created by Visakh on 10/09/18.
//  Copyright © 2018 Visakh. All rights reserved.
//

import UIKit

class WalletToWalletTableViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textFieldPhoneNumber             : UITextField!
    @IBOutlet weak var textFieldAmount                  : UITextField!
    @IBOutlet weak var buttonAlert                      : UIButton!
    @IBOutlet weak var viewAmontAndAlert                : UIView!
    @IBOutlet weak var buttonTransfer                   : UIButton!
    @IBOutlet weak var labelWalletAmount                : UILabel!
    var activeTextField                                 : UITextField!
    var toUserId                                        : Int!
    @IBOutlet weak var labelNameofAccountHolder: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.textFieldAmount.isUserInteractionEnabled = false
        self.setupUI()
        self.buttonAlert.isHidden = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(keyboardHide))
        self.view.addGestureRecognizer(tapGesture)
        self.addDoneButtonOnKeyboard()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.walletBalance()
    }
    
    
    func setupUI()  {
        textFieldPhoneNumber.layer.cornerRadius = 8
        textFieldPhoneNumber.layer.borderWidth = 1.0
        textFieldPhoneNumber.layer.borderColor = UIColor.lightGray.cgColor
        
        labelNameofAccountHolder.layer.cornerRadius = 8
        labelNameofAccountHolder.layer.borderWidth = 1.0
        labelNameofAccountHolder.layer.borderColor = UIColor.lightGray.cgColor
        
        viewAmontAndAlert.layer.cornerRadius = 8
        viewAmontAndAlert.layer.borderWidth = 1.0
        viewAmontAndAlert.layer.borderColor = UIColor.lightGray.cgColor
        
        buttonTransfer.layer.cornerRadius = 8
        buttonTransfer.layer.borderWidth = 1.0
        buttonTransfer.layer.borderColor = UIColor.lightGray.cgColor
        
        textFieldPhoneNumber.setLeftPaddingPoints(5.0)
        textFieldAmount.setLeftPaddingPoints(5.0)
        
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 10, width: self.view.frame.width, height: 50.0)
        let btn1 = UIButton(type: .custom)
        btn1.setImage(UIImage(named: "Notification_button_3x"), for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        btn1.addTarget(self, action: #selector(notificationAction), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: btn1)
        
        /*let btn2 = UIButton(type: .custom)
         btn2.setImage(UIImage(named: "Notification_button_3x"), for: .normal)
         btn2.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
         btn2.addTarget(self, action: #selector(notificationAction), for: .touchUpInside)
         let item2 = UIBarButtonItem(customView: btn2)*/
        self.navigationItem.setLeftBarButton(item1, animated: true)
        let btnMenu = UIButton(type: .custom)
        btnMenu.setImage(#imageLiteral(resourceName: "Back_Button_3x"), for: .normal)
        btnMenu.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        btnMenu.addTarget(self, action: #selector(sideMenuAction), for: .touchUpInside)
        let item3 = UIBarButtonItem(customView: btnMenu)
        self.navigationItem.setLeftBarButton(item3, animated: true)
        
        
        self.navigationItem.title = "Trasfer"
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.red]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        
    }

    //MARK: walletBalance
    func walletBalance() {
        let hud = GenericFunctions.showJHud(target: self)
        AlamofireSubclass.parseLinkUsingGetMethod("wallet/balance/\(String(User.current.user_details!.u_id!))") { (success, response, error) in
            hud.hide()
            if success == true {
                self.labelWalletAmount.text = String(describing: (response!["wallet_balance"] as! Double))
                
            }else{
                GenericFunctions.showAlertView(targetVC: self, title: "Error", message: (error?.localizedDescription)!)
            }
        }
    }
    //MARK:- Button Actions
    
    @IBAction func buttonTrasferAmountAction(_ sender: UIButton) {
        if buttonTransfer.currentTitle == "Transfer"{
            if textFieldPhoneNumber.text?.isEmpty == false{
                if textFieldAmount.text?.isEmpty == false{
                    self.walletToWalletTransfer()
                }else{
                    GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Please enter transfer amount")
                }
                
            }else{
                GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Please enter recipient mobile number")
            }
        }else{
            let rechargeVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            // rechargeVC.pageID = self.pageID
            self.navigationController?.pushViewController(rechargeVC, animated: true)
        }
    }
    
    
    @objc func notificationAction() {
        
    }
    //MARK:- Toggle SideMenu
    @objc func sideMenuAction() {
        //menuContainerViewController.toggleLeftSideMenuCompletion(nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Textfield Delegats
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let balance = labelWalletAmount.text!
        let amount = textFieldAmount.text!
        
        
        if activeTextField == textFieldPhoneNumber {
            
        }else if activeTextField == textFieldAmount {
            if balance < amount {
                self.buttonAlert.isHidden = false
                self.buttonTransfer.setTitle("Recharge", for: .normal)
            }else{
                self.buttonAlert.isHidden = true
                self.buttonTransfer.setTitle("Transfer", for: .normal)
            }
            
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        let balance = labelWalletAmount.text!
        let amount = textFieldAmount.text!
        
        if activeTextField == textFieldAmount {
            if balance < amount {
                self.buttonAlert.isHidden = false
                self.buttonTransfer.setTitle("Recharge", for: .normal)
            }else{
                self.buttonAlert.isHidden = true
                self.buttonTransfer.setTitle("Transfer", for: .normal)
            }
        }else if activeTextField == textFieldPhoneNumber {
            if newString.count > 10 {
                self.checkPhoneNumberExist()
                textField.resignFirstResponder()
            }
        }
        
        return true
    }
    
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
        textFieldPhoneNumber.inputAccessoryView = doneToolbar
        textFieldAmount.inputAccessoryView = doneToolbar
        
    }
    @objc func doneButtonAction() {
        let balance = labelWalletAmount.text!
        let amount = textFieldAmount.text!
        
        if activeTextField == textFieldAmount{
            if textFieldAmount.text?.isEmpty == false{
                let bal = Float(balance)!
                let amt = Float(amount)!
                if bal < amt {
                    self.buttonAlert.isHidden = false
                    self.buttonTransfer.setTitle("Recharge", for: .normal)
                    
                }else{
                    self.buttonAlert.isHidden = true
                    self.buttonTransfer.setTitle("Transfer", for: .normal)
                }
                
            }else{
                textFieldAmount.resignFirstResponder()
            }
        }else if textFieldPhoneNumber.text?.isEmpty == false {
            checkPhoneNumberExist()
            self.activeTextField.resignFirstResponder()
            
        }else{
            activeTextField.resignFirstResponder()
        }
        
        
        activeTextField.resignFirstResponder()
    }
    
    @objc func keyboardHide()  {
        textFieldAmount.resignFirstResponder()
        textFieldPhoneNumber.resignFirstResponder()
    }
    
    //MARK:- API Phone number existency check
    func checkPhoneNumberExist() {
        let hud = GenericFunctions.showJHud(target: self)
        AlamofireSubclass.parseLinkUsingGetMethod("wallet/check/\(self.textFieldPhoneNumber.text!)") { (success, response, error) in
            hud.hide()
            if success == true {
                if response!["status"] as! Bool == true{
                    let userDict = response!["data"] as! NSDictionary
                    self.toUserId = userDict["u_id"] as! Int
                    self.textFieldAmount.isUserInteractionEnabled = true
                    self.labelNameofAccountHolder.text = "\(userDict["u_first_name"] as! String) \(userDict["u_last_name"] as! String)"
                    
                }
                else{
                    GenericFunctions.showAlertView(targetVC: self, title: "Error", message: "Phone number does not exist")
                    self.textFieldAmount.isUserInteractionEnabled = false
                    
                }
            }else{
                GenericFunctions.showAlertView(targetVC: self, title: "Error", message: (error?.localizedDescription)!)
            }
        }
    }
    //MARK:- API Wallet to wallet trasnfer
    func walletToWalletTransfer()  {
        var params  : NSDictionary?
        
        params = ["from" : String(User.current.user_details!.u_id!), "to" : String(toUserId!), "amount": textFieldAmount.text!]
        let hud = GenericFunctions.showJHud(target: self)
        AlamofireSubclass.parseLinkUsingPostMethod("wallet/transfer/user", with: params!) { (success, response, error) in
            hud.hide()
            if success == true{
                if response!["message"] as! String == "Amount mooved successfully" {
                    self.walletBalance()
                    let alert = UIAlertController(title: "Message", message: "Amount mooved successfully", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction((UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in
                        DispatchQueue.main.async {
                            self.navigationController?.popViewController(animated: true)
                        }
                    })))
                    self.present(alert, animated: true, completion: nil)
                    
                }else{
                    GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Please try again")
                }
            }else{
                GenericFunctions.showAlertView(targetVC: self, title: "Message", message: (error?.localizedDescription)!)
            }
            
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
