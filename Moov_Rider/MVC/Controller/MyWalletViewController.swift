//
//  MyWalletViewController.swift
//  Moov_Rider
//
//  Created by Visakh on 19/07/18.
//  Copyright © 2018 Visakh. All rights reserved.
//

import UIKit

class MyWalletViewController: UIViewController {

    @IBOutlet weak var labelWalletAmount                : UILabel!
    @IBOutlet weak var buttonRecharge                   : UIButton!
    var pageID                                          : String!
    
    @IBOutlet weak var walletToWallet: UIButton!
    @IBOutlet weak var walletToBank: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.walletBalance()
    }
    
    func setupUI()  {
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
        
        
        self.navigationItem.title = "MY WALLET"
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.red]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        self.buttonRecharge.layer.cornerRadius = 20.0
        
        self.walletToBank.layer.cornerRadius = 20.0
        self.walletToWallet.layer.cornerRadius = 20.0
        
        
       
        
    }
    @objc func notificationAction() {
        
    }
    //MARK:- Toggle SideMenu
    @objc func sideMenuAction() {
        //menuContainerViewController.toggleLeftSideMenuCompletion(nil)
        self.navigationController?.popViewController(animated: true)
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
    
    @IBAction func buttonRechargeAction(_ sender: UIButton) {
       // let rechargeVC = self.storyboard?.instantiateViewController(withIdentifier: "RechargeViewController") as! RechargeViewController
        let rechargeVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        rechargeVC.pageID = self.pageID
        self.navigationController?.pushViewController(rechargeVC, animated: true)
        
    }
    @IBAction func buttonTransferAction(_ sender: UIButton) {
        let wallletToWalletVc = self.storyboard?.instantiateViewController(withIdentifier: "WalletToWalletTableViewController") as! WalletToWalletTableViewController
        self.navigationController?.pushViewController(wallletToWalletVc, animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}
