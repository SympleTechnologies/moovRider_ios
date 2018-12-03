//
//  ViewController.swift
//  Paystack iOS Exampe (Simple)
//

import UIKit
import Paystack

class ViewController: UIViewController, PSTCKPaymentCardTextFieldDelegate {
    
    @IBOutlet weak var textFieldEnterAmount: UITextField!
    var pageID    : String!
    // MARK: REPLACE THESE
    // Replace these values with your application's keys
    // Find this at https://dashboard.paystack.co/#/settings/developer
   // let paystackPublicKey = "pk_test_1544ffee69407a91be7cece08566ea4ca1343126"
     let paystackPublicKey = "pk_live_808cad3e44ee879630593bfd58a7d39a18631f54"
    
    // To set this up, see https://github.com/PaystackHQ/sample-charge-card-backend
    let backendURLString = ""
    // let backendURLString = "https://calm-scrubland-33409.herokuapp.com"
    
    let card : PSTCKCard = PSTCKCard()
    
    
    override func viewDidLoad() {
        
        tokenLabel.text=nil
        chargeCardButton.isEnabled = false
        // clear text from card details
        // comment these to use the sample data set
        super.viewDidLoad();
        chargeCardButton.layer.cornerRadius = 8.0
        chargeCardButton.layer.masksToBounds = true
        textFieldEnterAmount.layer.cornerRadius = 8.0
        textFieldEnterAmount.layer.borderColor = UIColor.lightGray.cgColor
        textFieldEnterAmount.layer.borderWidth = 1.0
        textFieldEnterAmount.layer.masksToBounds = true
        
        let btnMenu = UIButton(type: .custom)
        btnMenu.setImage(#imageLiteral(resourceName: "Back_Button_3x"), for: .normal)
        btnMenu.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        btnMenu.addTarget(self, action: #selector(sideMenuAction), for: .touchUpInside)
        let item3 = UIBarButtonItem(customView: btnMenu)
        self.navigationItem.setLeftBarButton(item3, animated: true)
        
        
        self.navigationItem.title = "Recharge"
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.red]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        
        let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10, height: textFieldEnterAmount.frame.height))
        textFieldEnterAmount.leftView = leftView
        textFieldEnterAmount.leftViewMode = .always
        
        
    }
    //MARK:- Toggle SideMenu
    @objc func sideMenuAction() {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    // MARK: Helpers
    func showOkayableMessage(_ title: String, message: String){
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.alert
        )
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func dismissKeyboardIfAny(){
        // Dismiss Keyboard if any
        cardDetailsForm.resignFirstResponder()
        txtFldAmount.resignFirstResponder()
        
    }
    
    
    // MARK: Properties
    @IBOutlet weak var cardDetailsForm: PSTCKPaymentCardTextField!
    @IBOutlet weak var txtFldAmount: UITextField!
    @IBOutlet weak var chargeCardButton: UIButton!
    @IBOutlet weak var tokenLabel: UILabel!
    
    // MARK: Actions
    @IBAction func cardDetailsChanged(_ sender: PSTCKPaymentCardTextField) {
        chargeCardButton.isEnabled = sender.isValid
        if sender.isValid == true {
            Paystack.setDefaultPublicKey(paystackPublicKey)
            if txtFldAmount.text != "" {
                if cardDetailsForm.isValid {
                    print("valid")
                    dismissKeyboardIfAny()
                    
                    self.rechargeUsingPayStack()
                }
            }else {
                GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Please enter the amount")
            }
        }else {
            print(" not valid")
        }
    }
    
    func rechargeUsingPayStack()  {
        let hud = GenericFunctions.showJHud(target: self)
        AlamofireSubclass.parseLinkUsingPostMethod("wallet/init_payment", with: ["amount": txtFldAmount.text!,"userid": String(User.current.user_details!.u_id!)]) { (success, response, error) in
            hud.hide()
            if success  == true {
                if response!["message"] as! String == "Authorization URL created" {
                    let detailDict: NSDictionary = response!["data"] as! NSDictionary
                    
                    self.chargeWithSDK(newCode: detailDict["access_code"] as! String)
                }else{
                    GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Authorization Failed")
                }
            }else{
                GenericFunctions.showAlertView(targetVC: self, title: "Message", message: (error?.localizedDescription)!)
            }
        }
        
    }
    
    
    
    @IBAction func chargeCard(_ sender: UIButton) {
        dismissKeyboardIfAny()
        if txtFldAmount.text != "" {
            if cardDetailsForm.isValid {
                print("valid")
                dismissKeyboardIfAny()
                self.rechargeUsingPayStack()
            }
        }else {
            GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Please enter the amount")
        }
        
    }
    
    func outputOnLabel(str: String){
        DispatchQueue.main.async {
            if let former = self.tokenLabel.text {
                self.tokenLabel.text = former + "\n" + str
            } else {
                self.tokenLabel.text = str
            }
        }
    }
    
    func fetchAccessCodeAndChargeCard(){
        if let url = URL(string: backendURLString  + "/new-access-code") {
            self.makeBackendRequest(url: url, message: "fetching access code", completion: { str in
                self.outputOnLabel(str: "Fetched access code: "+str)
                self.chargeWithSDK(newCode: str as String)
            })
        }
    }
    
    func chargeWithSDK(newCode: String){
        let transactionParams = PSTCKTransactionParams.init();
        transactionParams.access_code = newCode as String;
        // transactionParams.reference =
        // use library to create charge and get its reference
        let hud = GenericFunctions.showJHud(target: self)
        PSTCKAPIClient.shared().chargeCard(self.cardDetailsForm.cardParams, forTransaction: transactionParams, on: self, didEndWithError: { (error, reference) in
            hud.hide()
            self.outputOnLabel(str: "Charge errored")
            // what should I do if an error occured?
            print(error)
            if error._code == PSTCKErrorCode.PSTCKExpiredAccessCodeError.rawValue{
                // access code could not be used
                // we may as well try afresh
            }
            if error._code == PSTCKErrorCode.PSTCKConflictError.rawValue{
                // another transaction is currently being
                // processed by the SDK... please wait
            }
            if let errorDict = (error._userInfo as! NSDictionary?){
                if let errorString = errorDict.value(forKeyPath: "com.paystack.lib:ErrorMessageKey") as! String? {
                    if let reference=reference {
                        // self.showOkayableMessage("An error occured while completing "+reference, message: errorString)
                        self.outputOnLabel(str: reference + ": " + errorString)
                        self.verifyTransaction(reference: reference)
                    } else {
                        //self.showOkayableMessage("An error occured", message: errorString)
                        self.outputOnLabel(str: errorString)
                    }
                }
            }
            self.chargeCardButton.isEnabled = true;
        }, didRequestValidation: { (reference) in
            self.outputOnLabel(str: "requested validation: " + reference)
        }, willPresentDialog: {
            // make sure dialog can show
            // if using a "processing" dialog, please hide it
            self.outputOnLabel(str: "will show a dialog")
        }, dismissedDialog: {
            // if using a processing dialog, please make it visible again
            self.outputOnLabel(str: "dismissed dialog")
        }) { (reference) in
            self.outputOnLabel(str: "succeeded: " + reference)
            self.chargeCardButton.isEnabled = true;
            self.verifyTransaction(reference: reference)
        }
        return
    }
    
    func verifyTransaction(reference: String){
        let hud = GenericFunctions.showJHud(target: self)
        AlamofireSubclass.parseLinkUsingPostMethod("wallet/verify", with: ["reference": reference,"userid": String(User.current.user_details!.u_id!)]) { (success, response, error) in
            hud.hide()
            if success  == true {
                if response!["message"] as! String == "Wallet Recharged Successfully" {
                    let alert = UIAlertController(title: "Message", message: "Bank charges applies", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction((UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in
                        DispatchQueue.main.async {
                            //self.navigationController?.popViewController(animated: true)
                            if self.pageID == "Recharge"{
                                
                                for controller in self.navigationController!.viewControllers as Array {
                                    if controller.isKind(of: SelectSeatsViewController.self) {
                                        self.navigationController!.popToViewController(controller, animated: true)
                                        break
                                    }
                                }
                            }else if self.pageID == "Future Booking"{
                                for controller in self.navigationController!.viewControllers as Array {
                                    if controller.isKind(of: FutureBookingViewController.self) {
                                        self.navigationController!.popToViewController(controller, animated: true)
                                        break
                                    }
                                }
                            }else{
                                self.navigationController?.popViewController(animated: true)
                            }
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
        
        
        
        /* if let url = URL(string: backendURLString  + "/verify/" + reference) {
         makeBackendRequest(url: url, message: "verifying " + reference, completion:{(str) -> Void in
         self.outputOnLabel(str: "Message from paystack on verifying " + reference + ": " + str)
         })
         }*/
    }
    
    func makeBackendRequest(url: URL, message: String, completion: @escaping (_ result: String) -> Void){
        let session = URLSession(configuration: URLSessionConfiguration.default)
        self.outputOnLabel(str: "Backend: " + message)
        session.dataTask(with: url, completionHandler: { data, response, error in
            let successfulResponse = (response as? HTTPURLResponse)?.statusCode == 200
            if successfulResponse && error == nil && data != nil {
                if let str = NSString(data: data!, encoding: String.Encoding.utf8.rawValue){
                    completion(str as String)
                } else {
                    self.outputOnLabel(str: "<Unable to read response> while "+message)
                    print("<Unable to read response>")
                }
            } else {
                if let e=error {
                    print(e.localizedDescription)
                    self.outputOnLabel(str: e.localizedDescription)
                } else {
                    // There was no error returned though status code was not 200
                    print("There was an error communicating with your payment backend.")
                    self.outputOnLabel(str: "There was an error communicating with your payment backend while "+message)
                }
            }
        }).resume()
    }
    
    
}
