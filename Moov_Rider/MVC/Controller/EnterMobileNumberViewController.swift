//
//  EnterMobileNumberViewController.swift
//  Moov_Rider
//
//  Created by Visakh on 17/07/18.
//  Copyright © 2018 Visakh. All rights reserved.
//

import UIKit

class EnterMobileNumberViewController: UIViewController, MICountryPickerDelegate {

    @IBOutlet weak var textFieldCountryCode     : UITextField!
    @IBOutlet weak var viewEnterMobileNumber    : UIView!
    @IBOutlet weak var buttonNext               : UIButton!
    @IBOutlet weak var textFieldMobileNumber    : UITextField!
    let countryPicker                           = MICountryPicker()
    
    var firstname                               : String!
    var surName                                 : String!
    var emailID                                 : String!
    var password                                : String!
    var collegeID                               : Int!
    var userRoleID                              : Int!
    var imageData                               : Data!
    var authMode                                : String!
    var authProvider                            : String!
    var authUID                                 : String!
    var imageUrl                                : String!
     var appDelegate                            : AppDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(keyboardHide))
        self.view.addGestureRecognizer(tapGesture)
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            self.textFieldCountryCode.text = getCountryCallingCode(countryRegionCode: countryCode)
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
        self.textFieldMobileNumber.inputAccessoryView          = doneToolbar
    }
    @objc func doneButtonAction() {
        self.textFieldMobileNumber.resignFirstResponder()
    }

    func setupUI()  {
        textFieldMobileNumber.leftViewMode = .always
        let imageView = UIImageView(frame:CGRect(x: 0, y: 0, width: 10, height: 35))
        imageView.image = UIImage()
        let paddingView = UIView(frame:CGRect(x: 0, y: 0, width: 10, height: textFieldMobileNumber.frame.height))
        let paddingViewV = UIView(frame:CGRect(x: 0, y: 0, width: 10, height: textFieldMobileNumber.frame.height))
        imageView.center = paddingView.center
        paddingView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        paddingViewV.addSubview(paddingView)
        paddingViewV.backgroundColor = UIColor.clear
        textFieldMobileNumber.leftView = paddingViewV
        
        self.buttonNext.layer.cornerRadius = 10.0
        self.textFieldMobileNumber.layer.borderColor = UIColor.lightGray.cgColor
        self.textFieldMobileNumber.layer.borderWidth =  1.0
        self.viewEnterMobileNumber.layer.borderColor = UIColor.lightGray.cgColor
        self.viewEnterMobileNumber.layer.borderWidth =  1.0
        
//        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 10, width: self.view.frame.width, height: 50.0)
//        let btnMenu = UIButton(type: .custom)
//        btnMenu.setImage(#imageLiteral(resourceName: "Back_Button_3x"), for: .normal)
//        btnMenu.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
//        btnMenu.addTarget(self, action: #selector(sideMenuAction), for: .touchUpInside)
//        let item3 = UIBarButtonItem(customView: btnMenu)
//        self.navigationItem.setLeftBarButton(item3, animated: true)

        /*let logo = UIImage(named: "Let’s moov!")
         let imageViewLogo = UIImageView(image:logo)
         self.navigationItem.titleView = imageViewLogo*/
        self.navigationItem.title = "Moov"
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.red]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        
    }
    //MARK:- Country codes
    func getCountryCallingCode(countryRegionCode:String)->String{
        
        let prefixCodes = ["AF" : "+93","AE" : "+971","AL" : "+355","AN" : "+599","AS" : "+1","AD" : "+376","AO" : "+244","AI" : "+1","AG" : "+1","AR" : "+54","AM" : "+374","AW" : "+297","AU" : "+61","AT" : "+43","AZ" : "+994","BS" : "+1","BH" : "+973","BF" : "+226","BI" : "+257","BD" : "+880","BB" : "+1","BY" : "+375","BE" : "+32","BZ" : "+501","BJ" : "+229","BM" : "+1","BT" : "+975","BA" : "+387","BW" : "+267","BR" : "+55","BG" : "+359","BO" : "+591","BL" : "+590","BN" : "+673","CC" : "+61","CD" : "+243","CI" : "+225","KH" : "+855","CM" : "+237","CA" : "+1","CV" : "+238","KY" : "+345","CF" : "+236","CH" : "+41","CL" : "+56","CN" : "+86","CX" : "+61","CO" : "+57","KM" : "+269","CG" : "+242","CK" : "+682","CR" : "+506","CU" : "+53","CY" : "+537","CZ" : "+420","DE" : "+49","DK" : "+45","DJ" : "+253","DM" : "+1","DO" : "+1","DZ" : "+213","EC" : "+593","EG" : "+20","ER" : "+291","EE" : "+372","ES" : "+34","ET" : "+251","FM" : "+691","FK" : "+500","FO" : "+298","FJ" : "+679","FI" : "+358","FR" : "+33","GB" : "+44","GF" : "+594","GA" : "+241","GS" : "+500","GM" : "+220","GE" : "+995","GH" : "+233","GI" : "+350","GQ" : "+240","GR" : "+30","GG" : "+44","GL" : "+299","GD" : "+1","GP" : "+590","GU" : "+1","GT" : "+502","GN" : "+224","GW" : "+245","GY" : "+595","HT" : "+509","HR" : "+385","HN" : "+504","HU" : "+36","HK" : "+852","IR" : "+98","IM" : "+44","IL" : "+972","IO" : "+246","IS" : "+354","IN" : "+91","ID" : "+62","IQ" : "+964","IE" : "+353","IT" : "+39","JM" : "+1","JP" : "+81","JO" : "+962","JE" : "+44","KP" : "+850","KR" : "+82","KZ" : "+77","KE" : "+254","KI" : "+686","KW" : "+965","KG" : "+996","KN" : "+1","LC" : "+1","LV" : "+371","LB" : "+961","LK" : "+94","LS" : "+266","LR" : "+231","LI" : "+423","LT" : "+370","LU" : "+352","LA" : "+856","LY" : "+218","MO" : "+853","MK" : "+389","MG" : "+261","MW" : "+265","MY" : "+60","MV" : "+960","ML" : "+223","MT" : "+356","MH" : "+692","MQ" : "+596","MR" : "+222","MU" : "+230","MX" : "+52","MC" : "+377","MN" : "+976","ME" : "+382","MP" : "+1","MS" : "+1","MA" : "+212","MM" : "+95","MF" : "+590","MD" : "+373","MZ" : "+258","NA" : "+264","NR" : "+674","NP" : "+977","NL" : "+31","NC" : "+687","NZ" : "+64","NI" : "+505","NE" : "+227","NG" : "+234","NU" : "+683","NF" : "+672","NO" : "+47","OM" : "+968","PK" : "+92","PM" : "+508","PW" : "+680","PF" : "+689","PA" : "+507","PG" : "+675","PY" : "+595","PE" : "+51","PH" : "+63","PL" : "+48","PN" : "+872","PT" : "+351","PR" : "+1","PS" : "+970","QA" : "+974","RO" : "+40","RE" : "+262","RS" : "+381","RU" : "+7","RW" : "+250","SM" : "+378","SA" : "+966","SN" : "+221","SC" : "+248","SL" : "+232","SG" : "+65","SK" : "+421","SI" : "+386","SB" : "+677","SH" : "+290","SD" : "+249","SR" : "+597","SZ" : "+268","SE" : "+46","SV" : "+503","ST" : "+239","SO" : "+252","SJ" : "+47","SY" : "+963","TW" : "+886","TZ" : "+255","TL" : "+670","TD" : "+235","TJ" : "+992","TH" : "+66","TG" : "+228","TK" : "+690","TO" : "+676","TT" : "+1","TN" : "+216","TR" : "+90","TM" : "+993","TC" : "+1","TV" : "+688","UG" : "+256","UA" : "+380","US" : "+1","UY" : "+598","UZ" : "+998","VA" : "+379","VE" : "+58","VN" : "+84","VG" : "+1","VI" : "+1","VC" : "+1","VU" : "+678","WS" : "+685","WF" : "+681","YE" : "+967","YT" : "+262","ZA" : "+27","ZM" : "+260","ZW" : "+263"]
        let countryDialingCode = prefixCodes[countryRegionCode]
        return countryDialingCode!
    }
    
    
    
    //    MARK:- MICountryPicker Delegate
    func countryPicker(_ picker: MICountryPicker, didSelectCountryWithName name: String, code: String) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func countryPicker(_ picker: MICountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String) {
        textFieldCountryCode.text   =   dialCode
        
    }
    //MARK:- Button Actions
   
    @IBAction func buttonSignUpActions(_ sender: UIButton) {
        if textFieldMobileNumber.text?.isEmpty == false && textFieldCountryCode.text?.isEmpty == false {
                self.registration()
        }else{
            GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Please fill all fields")
        }
    }
    @IBAction func buttonCountryPickerAction(_ sender: UIButton) {
        countryPicker.delegate = self
        countryPicker.showCallingCodes = true
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.pushViewController(countryPicker, animated: true)
    }
    //MARK: API Registration
    
    func registration()  {
        
        var params  : NSDictionary?
        var imageData = Data()
        let usertype = String(userRoleID!)
        let collegeId = String(collegeID!)
        if authProvider == "google"{
             params = ["f_name": firstname!,"l_name": surName!, "email": emailID!, "password":"", "college": collegeId,"phone": self.textFieldMobileNumber.text!, "gender": "", "user_type": usertype, "auth_mode": authMode!,"auth_provider":authProvider!,"auth_uid":authUID!,"phone_country": self.textFieldCountryCode.text!, "image": imageUrl!,"device_type":"iOS","device_id":appDelegate.deviceTokenStr!,"push_token": appDelegate.deviceTokenStr!,"app_version":"1.2"]
            imageData = self.imageData
        }else if authProvider == "facebook" {
            params = ["f_name": firstname!,"l_name": surName!, "email": emailID!, "password": password!, "college": collegeId,"phone": self.textFieldMobileNumber.text!, "gender": "", "user_type": usertype, "auth_mode": authMode!,"auth_provider":authProvider!,"auth_uid":authUID!,"phone_country": self.textFieldCountryCode.text!, "image": imageUrl!,"device_type":"iOS","device_id":appDelegate.deviceTokenStr!,"push_token": appDelegate.deviceTokenStr!,"app_version":"1.2"]
        } else{
            params = ["f_name": firstname!,"l_name": surName!, "email": emailID!, "password": password!, "college": collegeId,"phone": self.textFieldMobileNumber.text!, "gender": "", "user_type": usertype, "auth_mode": "email","auth_provider":"","auth_uid":"","phone_country": self.textFieldCountryCode.text!,"device_type":"iOS","device_id":appDelegate.deviceTokenStr!,"push_token": appDelegate.deviceTokenStr!,"app_version":"1.2"]
        }
        let hud = GenericFunctions.showJHud(target: self)
            AlamofireSubclass.parseLinkUsingPostMethod("auth/register", with: params!, completion: { (success, response, error) in
            hud.hide()
            if success == true {
                if response!["message"]as! String == "login success" {
                    //GenericFunctions.showAlertView(targetVC: self, title: "Success", message: "Succesfully updated your profile")
                    /*for controller in self.navigationController!.viewControllers as Array {
                        if controller.isKind(of: LoginTableViewController.self) {
                            self.navigationController!.popToViewController(controller, animated: true)
                            break
                        }
                    }*/
                    let userDict = response!["data"] as! NSDictionary
                    User.current.initWithDictionary(dictionary: userDict)
                    User.saveLoggedUserdetails(dictDetails: userDict)
                    let homePage = self.storyboard?.instantiateViewController(withIdentifier: "EnterDestinationViewController")
                        as! EnterDestinationViewController
                    let navVC = UINavigationController(rootViewController: homePage)
                    let sideVC = self.storyboard?.instantiateViewController(withIdentifier: "SideMenuTableViewController") as! SideMenuTableViewController
                    let mfContainer = MFSideMenuContainerViewController.container(withCenter: navVC, leftMenuViewController: sideVC, rightMenuViewController: nil)
                    UIApplication.shared.keyWindow?.rootViewController = mfContainer
                    
                }else {
                    GenericFunctions.showAlertView(targetVC: self, title: "Message", message: response!["message"]as! String)
                }
            }else {
                
                GenericFunctions.showAlertView(targetVC: self, title: "Message", message: (error?.localizedDescription)!)
            }
        })
        
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func keyboardHide()  {
        textFieldMobileNumber.resignFirstResponder()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldMobileNumber.resignFirstResponder()
        
        return true
    }
//    @objc func sideMenuAction() {
//        self.navigationController?.popViewController(animated: true)
//    }

   

}
