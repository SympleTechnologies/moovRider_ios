//
//  WalletToBankViewController.swift
//  Moov_Rider
//
//  Created by Visakh on 07/09/18.
//  Copyright © 2018 Visakh. All rights reserved.
//

import UIKit

class WalletToBankViewController: UIViewController, NIDropDownDelegate, UITextFieldDelegate{

    @IBOutlet weak var heightConstrain: NSLayoutConstraint!
    @IBOutlet weak var labelWalletBalance                       : UILabel!
    @IBOutlet weak var textFieldAmount                          : UITextField!
    @IBOutlet weak var ViewBackGround                           : UIView!
    @IBOutlet weak var textFieldAccountNumber                   : UITextField!
    @IBOutlet weak var textFieldBankName                        : UITextField!
    @IBOutlet weak var textFieldName                            : UITextField!
    @IBOutlet weak var buttonTransfer                           : UIButton!
    @IBOutlet weak var viewWarning: UIView!
    
    @IBOutlet weak var buttonAlert                              : UIButton!
    var arraBankList                                            : NSMutableArray!
    var arrayBankNameList                                       : [bankList]!
    
    var previousDropBtn                                         : UIButton!
    var isDropDownOpen                                          = Bool()
    var nidropDown                                              = NIDropDown()
    var dropdownArr                                             = NSArray()
    var selectUniversity                                        = Bool()
    var bankId                                                  : String!
    var activeTextField                                         : UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.walletBalance()
        self.getBankList()
        nidropDown.delegate = self
        self.addDoneButtonOnKeyboard()
        self.buttonAlert.isHidden = true
        self.buttonTransfer.isUserInteractionEnabled = false
        //let tapGesture = UITapGestureRecognizer(target: self, action: #selector(keyboardHide))
        //self.view.addGestureRecognizer(tapGesture)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow) , name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

    }
    
    func setupUI()  {
        ViewBackGround.layer.cornerRadius = 8
        ViewBackGround.layer.borderWidth = 1.0
        ViewBackGround.layer.borderColor = UIColor.lightGray.cgColor
        
        viewWarning.layer.cornerRadius = 8
        viewWarning.layer.borderWidth = 1.0
        viewWarning.layer.borderColor = UIColor.lightGray.cgColor
        
        textFieldBankName.layer.cornerRadius = 8
        textFieldBankName.layer.borderWidth = 1.0
        textFieldBankName.layer.borderColor = UIColor.lightGray.cgColor
        
        textFieldName.layer.cornerRadius = 8
        textFieldName.layer.borderWidth = 1.0
        textFieldName.layer.borderColor = UIColor.lightGray.cgColor
        
        textFieldAccountNumber.layer.cornerRadius = 8
        textFieldAccountNumber.layer.borderWidth = 1.0
        textFieldAccountNumber.layer.borderColor = UIColor.lightGray.cgColor
        
        buttonTransfer.layer.cornerRadius = 8
        buttonTransfer.layer.borderWidth = 1.0
        buttonTransfer.layer.borderColor = UIColor.lightGray.cgColor
        
        textFieldName.setLeftPaddingPoints(2.0)
        textFieldBankName.setLeftPaddingPoints(2.0)
        textFieldAccountNumber.setLeftPaddingPoints(2.0)
        textFieldAmount.setLeftPaddingPoints(2.0)

        
        
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
    
    //MARK:- API Bank List
    
    func getBankList()  {
        let hud = GenericFunctions.showJHud(target: self)
        AlamofireSubclass.parseLinkUsingGetMethod("wallet/banks") { (success, response, error) in
            hud.hide()
            if success == true {
                self.arrayBankNameList = [bankList]()
                self.arraBankList = NSMutableArray()
                if response!["message"] as! String == "Banks retrieved" {
                     let dataDict = response!["data"] as! NSArray
                    for dict in dataDict{
                        let objBank = bankList().initWith((dict as! NSDictionary))
                        self.arrayBankNameList.append(objBank)
                        self.arraBankList.add(objBank.bankName)
                        
                    }
                    
                }else{
                    GenericFunctions.showAlertView(targetVC: self, title: "Error", message: "Please try again")

                }
            }else{
                GenericFunctions.showAlertView(targetVC: self, title: "Error", message: (error?.localizedDescription)!)
            }
        }
    }
    
    //MARK: walletBalance
    func walletBalance() {
        let hud = GenericFunctions.showJHud(target: self)
        AlamofireSubclass.parseLinkUsingGetMethod("wallet/balance/\(String(User.current.user_details!.u_id!))") { (success, response, error) in
            hud.hide()
            if success == true {
                self.labelWalletBalance.text = String(describing: (response!["wallet_balance"] as! Double))
                
            }else{
                GenericFunctions.showAlertView(targetVC: self, title: "Error", message: (error?.localizedDescription)!)
            }
        }
    }
    //MARK: API Wallet To Bank Transfer
    
    func walletToBankTrasnfer()  {
        var params  : NSDictionary?
        params = ["name": textFieldName.text!, "account_number": textFieldAccountNumber.text!, "bank_code": bankId!, "amount" : textFieldAmount.text!, "userid": String(User.current.user_details!.u_id!)]
        let hud = GenericFunctions.showJHud(target: self)
        AlamofireSubclass.parseLinkUsingPostMethod("wallet/transfer/bank", with: params!) { (success, response, error) in
            hud.hide()
            if success == true{
                if response!["status"] as! Bool == true{
                    self.walletBalance()
                    let alert = UIAlertController(title: "Message", message: "Transfer Successfully Completed", preferredStyle: UIAlertControllerStyle.alert)
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
    
    //MARK:- Button Actions
    
    @objc func notificationAction() {
        
    }
    //MARK:- Toggle SideMenu
    @objc func sideMenuAction() {
        //menuContainerViewController.toggleLeftSideMenuCompletion(nil)
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonSelectBank(_ sender: UIButton) {
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
            nidropDown.show(sender,180.0, arraBankList as! [Any], nil, "down")
            //(sender, 120.0 , , nil, "down")
            isDropDownOpen = true
        }else {
            nidropDown.hide(sender)
        }
        previousDropBtn = sender
        
    }
    @IBAction func buttonTrasnferAction(_ sender: UIButton) {
        if textFieldName.text?.isEmpty == false{
            if textFieldBankName.text?.isEmpty == false{
                if textFieldAccountNumber.text?.isEmpty == false{
                    if textFieldAmount.text?.isEmpty == false{
                        self.walletToBankTrasnfer()
                        
                    }else{
                        GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Please enter the amount")
                    }
                    
                }else{
                    GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Please enter account number")
                }
                
            }else{
                GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Please select a bank")
            }
            
        }else{
            GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Please enter name of recipient")
        }
        
        
    }
    //MARK:- Add Done button Keyboard
    
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
        textFieldName.inputAccessoryView = doneToolbar
        textFieldAccountNumber.inputAccessoryView = doneToolbar
        textFieldAmount.inputAccessoryView = doneToolbar
        
    }
    @objc func doneButtonAction() {
        let balance = labelWalletBalance.text!
        let amount = textFieldAmount.text!
        if activeTextField == textFieldAmount{
            if textFieldAmount.text?.isEmpty == false {
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
                activeTextField.resignFirstResponder()
            }
        }
        
        textFieldAccountNumber.resignFirstResponder()
        textFieldAmount.resignFirstResponder()
        textFieldName.resignFirstResponder()
    }
    @objc func keyboardWillShow(notification: NSNotification) {
            self.heightConstrain.constant = 10
            if activeTextField == self.textFieldAccountNumber {
                self.heightConstrain.constant = self.heightConstrain.constant - 100
            }else if activeTextField == self.textFieldAmount {
                self.heightConstrain.constant = self.heightConstrain.constant - 120
            }
       
        UIView.animate(withDuration: 1, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        self.heightConstrain.constant = 10
        UIView.animate(withDuration: 1, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    //MARK:- Textfield Delegates
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    
    //MARK:- Dropdown delegate
    func niDropDownDelegateMethod(_ sender: UIButton!, selectedIndex index: Int32) {
        bankId = (arrayBankNameList[Int(index)].bankId as! String )
        
        self.textFieldBankName.text = (arraBankList[Int(index)] as! String)
        nidropDown.hide(previousDropBtn)
        nidropDown.removeFromSuperview()
        
        print(bankId!)
        
    }
    
    @objc func keyboardHide()  {
        textFieldName.resignFirstResponder()
        textFieldAmount.resignFirstResponder()
        textFieldAccountNumber.resignFirstResponder()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
   
}
extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
