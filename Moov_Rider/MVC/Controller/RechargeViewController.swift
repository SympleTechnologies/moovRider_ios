//
//  RechargeViewController.swift
//  Moov_Rider
//
//  Created by Visakh on 21/07/18.
//  Copyright © 2018 Visakh. All rights reserved.
//

import UIKit
import Paystack

class RechargeViewController: UIViewController, PSTCKPaymentCardTextFieldDelegate{

    @IBOutlet weak var textFieldCardHolderName                  : UITextField!
    @IBOutlet weak var textFieldCvv                             : UITextField!
    @IBOutlet weak var textFieldEnterAmount                     : UITextField!
    @IBOutlet weak var textFieldDate                            : UITextField!
    @IBOutlet weak var textFieldCardNumber                      : UITextField!
    @IBOutlet weak var viewtextFields                           : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
    }
    func setupUI()  {
        
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
        self.navigationItem.title = "Recharge Wallet"
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.red]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        textFieldEnterAmount.layer.cornerRadius = 5.0
        textFieldEnterAmount.layer.borderColor = UIColor.lightGray.cgColor
        textFieldEnterAmount.layer.borderWidth = 1.0
        
        let imageView = UIImageView(frame:CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.image = UIImage()
        let paddingView = UIView(frame:CGRect(x: 0, y: 0, width: 25, height: textFieldEnterAmount.frame.height))
        let paddingViewV = UIView(frame:CGRect(x: 0, y: 0, width: 25, height: textFieldEnterAmount.frame.height))
        imageView.center = paddingView.center
        paddingView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        paddingViewV.addSubview(paddingView)
        paddingViewV.backgroundColor = UIColor.clear
        textFieldEnterAmount.leftView = paddingViewV
        
        viewtextFields.layer.cornerRadius = 10.0
        viewtextFields.layer.borderColor = UIColor.lightGray.cgColor
        viewtextFields.layer.borderWidth = 1.0
        
        textFieldCardNumber.layer.cornerRadius = 5.0
        textFieldCardNumber.layer.borderColor = UIColor.lightGray.cgColor
        textFieldCardNumber.layer.borderWidth = 1.0
        
        textFieldDate.layer.cornerRadius = 5.0
        textFieldDate.layer.borderColor = UIColor.lightGray.cgColor
        textFieldDate.layer.borderWidth = 1.0
        
        textFieldCvv.layer.cornerRadius = 5.0
        textFieldCvv.layer.borderColor = UIColor.lightGray.cgColor
        textFieldCvv.layer.borderWidth = 1.0
        
        textFieldCardHolderName.layer.cornerRadius = 5.0
        textFieldCardHolderName.layer.borderColor = UIColor.lightGray.cgColor
        textFieldCardHolderName.layer.borderWidth = 1.0
        
        textFieldCvv.rightViewMode = .always
        let imageView1 = UIImageView(frame:CGRect(x: 0, y: 0, width: 35, height: 35))
        imageView1.image = #imageLiteral(resourceName: "cvv")
        let paddingView1 = UIView(frame:CGRect(x: 0, y: 0, width: 40, height: textFieldCvv.frame.height))
        let paddingViewW = UIView(frame:CGRect(x: 0, y: 0, width: 40, height: textFieldCvv.frame.height))
        imageView1.center = paddingView1.center
        paddingView1.addSubview(imageView1)
        imageView1.contentMode = .scaleAspectFit
        paddingViewW.addSubview(paddingView1)
        paddingViewW.backgroundColor = UIColor.clear
        textFieldCvv.rightView = paddingViewW
        
        
        
    }
    
    
    @objc func sideMenuAction() {
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}
