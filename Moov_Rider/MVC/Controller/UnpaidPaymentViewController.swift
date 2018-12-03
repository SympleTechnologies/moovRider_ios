//
//  UnpaidPaymentViewController.swift
//  Moov_Rider
//
//  Created by Visakh on 26/07/18.
//  Copyright © 2018 Visakh. All rights reserved.
//

import UIKit

class UnpaidPaymentViewController: UIViewController {

    @IBOutlet weak var viewBg                               : UIView!
    @IBOutlet weak var viewAlert                            : UIView!
    @IBOutlet weak var labelAmount                          : UILabel!
    @IBOutlet weak var buttonOk                             : UIButton!
    @IBOutlet weak var buttonCancel                         : UIButton!
    @IBOutlet weak var buttonAlertOk                        : UIButton!
    @IBOutlet weak var labelWalletBalance                   : UILabel!
    var rideID                                              : String!
    var rideAmount                                          : String!
    var walletBalanceAmount                                 : Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.walletBalance()
        self.viewAlert.isHidden = true
        self.viewBg.isHidden = false
        self.labelAmount.text = " $\(rideAmount!)"
    }
    func setupUI(){
        viewBg.layer.cornerRadius = 8.0
        viewBg.layer.borderWidth = 1.0
        viewBg.layer.borderColor = UIColor.lightGray.cgColor
        viewAlert.layer.cornerRadius = 8.0
        viewAlert.layer.borderWidth = 1.0
        viewAlert.layer.borderColor = UIColor.lightGray.cgColor
         buttonOk.layer.cornerRadius = 8.0
         buttonCancel.layer.cornerRadius = 8.0
         buttonAlertOk.layer.cornerRadius = 8.0
        
        let btnMenu = UIButton(type: .custom)
        btnMenu.setImage(#imageLiteral(resourceName: "Back_Button_3x"), for: .normal)
        btnMenu.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        btnMenu.addTarget(self, action: #selector(sideMenuAction), for: .touchUpInside)
        let item3 = UIBarButtonItem(customView: btnMenu)
        self.navigationItem.setLeftBarButton(item3, animated: true)
        
        self.navigationItem.title = "Payment"
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.red]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
    }
    //MARK:- Toggle SideMenu
    @objc func sideMenuAction() {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: walletBalance
    func walletBalance() {
        let hud = GenericFunctions.showJHud(target: self)
        AlamofireSubclass.parseLinkUsingGetMethod("wallet/balance/\(String(User.current.user_details!.u_id!))") { (success, response, error) in
            hud.hide()
            if success == true {
                self.labelWalletBalance.text = "Your current wallet balance is $\(String(describing: (response!["wallet_balance"] as! Double)))"
                self.walletBalanceAmount = response!["wallet_balance"] as! Double
            }else{
                GenericFunctions.showAlertView(targetVC: self, title: "Error", message: (error?.localizedDescription)!)
            }
        }
    }
    //MARK: API RidePAy
    func ridePay()  {
        let hud = GenericFunctions.showJHud(target: self)
        AlamofireSubclass.parseLinkUsingPostMethod("rides/pay", with: ["userid":String(User.current.user_details!.u_id),"ride_id":rideID!,"amount": rideAmount!]) { (success, response, error) in
            hud.hide()
            if success  == true {
                if response!["message"] as! String == "paid successfully"
                {
                    self.viewAlert.isHidden = false
                    self.viewBg.isHidden = true
                    
                }else{
                    GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Please try again")
                }
            }else{
                GenericFunctions.showAlertView(targetVC: self, title: "Message", message: (error?.localizedDescription)!)
            }
        }
    }
    
    //MARK:- ButtonActions
    
    @IBAction func buttonOkActions(_ sender: UIButton) {
        let rideAmt : Double = Double(rideAmount)!
        if walletBalanceAmount < rideAmt {
            let alert = UIAlertController(title: "Message", message: "You have insufficient balance. Do you want to recharge", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction((UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in
                let walletVc = self.storyboard?.instantiateViewController(withIdentifier: "MyWalletViewController") as! MyWalletViewController
                self.navigationController?.pushViewController(walletVc, animated: true)
            })))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }else{
             self.ridePay()
        }
        
        
        
    }
    @IBAction func buttonCancelActions(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonAlertOk(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
