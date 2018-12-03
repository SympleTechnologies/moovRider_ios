//
//  UpdatePhoneNumberViewController.swift
//  Moov_Rider
//
//  Created by Visakh on 24/07/18.
//  Copyright © 2018 Visakh. All rights reserved.
//

import UIKit

class UpdatePhoneNumberViewController: UIViewController, MICountryPickerDelegate{

    @IBOutlet weak var buttonOtpSend                    : UIButton!
    @IBOutlet weak var textFiledCountryCode             : UITextField!
    @IBOutlet weak var viewEnterPhoneNumber             : UIView!
    @IBOutlet weak var textFieldPhoneNumber             : UITextField!
    @IBOutlet weak var viewEnterOTP                     : UIView!
    @IBOutlet weak var textFieldOtp                     : UITextField!
    @IBOutlet weak var buttonSend                       : UIButton!
    let countryPicker                                   = MICountryPicker()

    override func viewDidLoad() {
        super.viewDidLoad()
        buttonSend.layer.cornerRadius = 8.0
        buttonOtpSend.layer.cornerRadius = 8.0
        self.viewEnterPhoneNumber.isHidden = false
        self.viewEnterOTP.isHidden = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(keyboardHide))
        self.view.addGestureRecognizer(tapGesture)
        
        let btnMenu = UIButton(type: .custom)
        btnMenu.setImage(#imageLiteral(resourceName: "Back_Button_3x"), for: .normal)
        btnMenu.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        btnMenu.addTarget(self, action: #selector(sideMenuAction), for: .touchUpInside)
        let item3 = UIBarButtonItem(customView: btnMenu)
        self.navigationItem.setLeftBarButton(item3, animated: true)
        
        
        self.navigationItem.title = "Settings"
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.red]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            self.textFiledCountryCode.text = getCountryCallingCode(countryRegionCode: countryCode)
        }
        self.addDoneButtonOnKeyboard()

    }
    //MARK:- ADD DONE BUTTON
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar  = UIToolbar(frame: CGRect(x:0, y:0, width:320, height:50))
        doneToolbar.barStyle        = UIBarStyle.default
        let flexSpace               = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
        
        //UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(.doneButtonAction) as Selector)
        var items           = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        doneToolbar.items   = items
        doneToolbar.sizeToFit()
        self.textFieldPhoneNumber.inputAccessoryView  = doneToolbar
        self.textFieldOtp.inputAccessoryView  = doneToolbar
        
    }
    @objc func doneButtonAction() {
        self.textFieldPhoneNumber.resignFirstResponder()
        self.textFieldOtp.resignFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addResetView(viewEnterPhoneNumber, frame: viewEnterPhoneNumber.frame)
    }
    func addResetView(_ view : UIView , frame : CGRect) {
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            let blurEffect                    = UIBlurEffect(style: UIBlurEffectStyle.dark)
            let blurEffectView                = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame              = self.view.bounds
            blurEffectView.autoresizingMask   = [.flexibleWidth, .flexibleHeight]
            
            self.view.addSubview(blurEffectView)
        } else {
            self.view.backgroundColor = UIColor.white
        }
        view.frame = frame
        view.center = self.view.center
        view.layer.cornerRadius = 5.0
        view.layer.masksToBounds = true
        self.view.addSubview(view)
        view.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }) { (sucess) in
        }
    }

    //MARK:- Country codes
    func getCountryCallingCode(countryRegionCode:String)->String{
        
        let prefixCodes = ["AF" : "+93","AE" : "+971","AL" : "+355","AN" : "+599","AS" : "+1","AD" : "+376","AO" : "+244","AI" : "+1","AG" : "+1","AR" : "+54","AM" : "+374","AW" : "+297","AU" : "+61","AT" : "+43","AZ" : "+994","BS" : "+1","BH" : "+973","BF" : "+226","BI" : "+257","BD" : "+880","BB" : "+1","BY" : "+375","BE" : "+32","BZ" : "+501","BJ" : "+229","BM" : "+1","BT" : "+975","BA" : "+387","BW" : "+267","BR" : "+55","BG" : "+359","BO" : "+591","BL" : "+590","BN" : "+673","CC" : "+61","CD" : "+243","CI" : "+225","KH" : "+855","CM" : "+237","CA" : "+1","CV" : "+238","KY" : "+345","CF" : "+236","CH" : "+41","CL" : "+56","CN" : "+86","CX" : "+61","CO" : "+57","KM" : "+269","CG" : "+242","CK" : "+682","CR" : "+506","CU" : "+53","CY" : "+537","CZ" : "+420","DE" : "+49","DK" : "+45","DJ" : "+253","DM" : "+1","DO" : "+1","DZ" : "+213","EC" : "+593","EG" : "+20","ER" : "+291","EE" : "+372","ES" : "+34","ET" : "+251","FM" : "+691","FK" : "+500","FO" : "+298","FJ" : "+679","FI" : "+358","FR" : "+33","GB" : "+44","GF" : "+594","GA" : "+241","GS" : "+500","GM" : "+220","GE" : "+995","GH" : "+233","GI" : "+350","GQ" : "+240","GR" : "+30","GG" : "+44","GL" : "+299","GD" : "+1","GP" : "+590","GU" : "+1","GT" : "+502","GN" : "+224","GW" : "+245","GY" : "+595","HT" : "+509","HR" : "+385","HN" : "+504","HU" : "+36","HK" : "+852","IR" : "+98","IM" : "+44","IL" : "+972","IO" : "+246","IS" : "+354","IN" : "+91","ID" : "+62","IQ" : "+964","IE" : "+353","IT" : "+39","JM" : "+1","JP" : "+81","JO" : "+962","JE" : "+44","KP" : "+850","KR" : "+82","KZ" : "+77","KE" : "+254","KI" : "+686","KW" : "+965","KG" : "+996","KN" : "+1","LC" : "+1","LV" : "+371","LB" : "+961","LK" : "+94","LS" : "+266","LR" : "+231","LI" : "+423","LT" : "+370","LU" : "+352","LA" : "+856","LY" : "+218","MO" : "+853","MK" : "+389","MG" : "+261","MW" : "+265","MY" : "+60","MV" : "+960","ML" : "+223","MT" : "+356","MH" : "+692","MQ" : "+596","MR" : "+222","MU" : "+230","MX" : "+52","MC" : "+377","MN" : "+976","ME" : "+382","MP" : "+1","MS" : "+1","MA" : "+212","MM" : "+95","MF" : "+590","MD" : "+373","MZ" : "+258","NA" : "+264","NR" : "+674","NP" : "+977","NL" : "+31","NC" : "+687","NZ" : "+64","NI" : "+505","NE" : "+227","NG" : "+234","NU" : "+683","NF" : "+672","NO" : "+47","OM" : "+968","PK" : "+92","PM" : "+508","PW" : "+680","PF" : "+689","PA" : "+507","PG" : "+675","PY" : "+595","PE" : "+51","PH" : "+63","PL" : "+48","PN" : "+872","PT" : "+351","PR" : "+1","PS" : "+970","QA" : "+974","RO" : "+40","RE" : "+262","RS" : "+381","RU" : "+7","RW" : "+250","SM" : "+378","SA" : "+966","SN" : "+221","SC" : "+248","SL" : "+232","SG" : "+65","SK" : "+421","SI" : "+386","SB" : "+677","SH" : "+290","SD" : "+249","SR" : "+597","SZ" : "+268","SE" : "+46","SV" : "+503","ST" : "+239","SO" : "+252","SJ" : "+47","SY" : "+963","TW" : "+886","TZ" : "+255","TL" : "+670","TD" : "+235","TJ" : "+992","TH" : "+66","TG" : "+228","TK" : "+690","TO" : "+676","TT" : "+1","TN" : "+216","TR" : "+90","TM" : "+993","TC" : "+1","TV" : "+688","UG" : "+256","UA" : "+380","US" : "+1","UY" : "+598","UZ" : "+998","VA" : "+379","VE" : "+58","VN" : "+84","VG" : "+1","VI" : "+1","VC" : "+1","VU" : "+678","WS" : "+685","WF" : "+681","YE" : "+967","YT" : "+262","ZA" : "+27","ZM" : "+260","ZW" : "+263"]
        let countryDialingCode = prefixCodes[countryRegionCode]
        return countryDialingCode!
    }
    
    
    //MARK:- Toggle SideMenu
    @objc func sideMenuAction() {
        self.dismiss(animated: true, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //    MARK:- MICountryPicker Delegate
    func countryPicker(_ picker: MICountryPicker, didSelectCountryWithName name: String, code: String) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func countryPicker(_ picker: MICountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String) {
        textFiledCountryCode.text   =   dialCode
        
    }
    @IBAction func buttonSelectCountryCode(_ sender: UIButton) {
        countryPicker.delegate = self
        countryPicker.showCallingCodes = true
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.pushViewController(countryPicker, animated: true)
    }
    @IBAction func buttonSendAction(_ sender: UIButton) {
        
        if textFiledCountryCode.text?.isEmpty == false{
            if textFieldPhoneNumber.text?.isEmpty == false{
                self.resetPhone()
                
            }else{
                GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Please enter your phone number")
            }
            
        }else{
            GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Please choose your country code")
        }
        
        
        
    }
    @IBAction func buttonOTPSubmitAction(_ sender: UIButton) {
        if textFieldOtp.text?.isEmpty == false{
                self.EnterOTP()
        }else{
            GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Please enter OTP")
        }
        
        
    }
    @IBAction func buttonCloseAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        
    }
    //MARK: Reset phone number
    
    func resetPhone()  {
        let hud = GenericFunctions.showJHud(target: self)
        AlamofireSubclass.parseLinkUsingPostMethod("update/phone/otp", with: ["userid": String(User.current.user_details!.u_id!),"phone":textFieldPhoneNumber.text!, "phone_country": textFiledCountryCode.text!]) { (success, response, error) in
            hud.hide()
            if success  == true {
                if response!["message"] as! String == "Otp send successfully"
                {
                    self.addResetView(self.viewEnterOTP, frame: self.viewEnterOTP.frame)
                    self.viewEnterOTP.isHidden = false
                    self.viewEnterPhoneNumber.isHidden = true
                    
                }else{
                    GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Phone number is  already exist")
                }
            }else{
                GenericFunctions.showAlertView(targetVC: self, title: "Message", message: (error?.localizedDescription)!)
            }
        }
        
    }
    //MARK: Reset phone number OTP
    
    func EnterOTP()  {
        let hud = GenericFunctions.showJHud(target: self)
        AlamofireSubclass.parseLinkUsingPostMethod("update/phone", with: ["userid": String(User.current.user_details!.u_id!),"phone":textFieldPhoneNumber.text!, "phone_country": textFiledCountryCode.text!, "otp": textFieldOtp.text!]) { (success, response, error) in
            hud.hide()
            if success  == true {
                
                let alert = UIAlertController(title: "Message", message: "Successfully Updated your phone number", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction((UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                })))
                self.present(alert, animated: true, completion: nil)
               
            }else{
                GenericFunctions.showAlertView(targetVC: self, title: "Message", message: (error?.localizedDescription)!)
            }
        }
        
    }
    @objc func keyboardHide()  {
        textFieldOtp.resignFirstResponder()
        textFieldPhoneNumber.resignFirstResponder()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldOtp.resignFirstResponder()
        textFieldPhoneNumber.resignFirstResponder()
        
        return true
    }


}
