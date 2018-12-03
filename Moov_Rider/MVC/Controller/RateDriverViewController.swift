//
//  RateDriverViewController.swift
//  Moov_Rider
//
//  Created by Visakh on 18/07/18.
//  Copyright © 2018 Visakh. All rights reserved.
//

import UIKit

class RateDriverViewController: UIViewController, UITextFieldDelegate {

   
    @IBOutlet weak var bottomConstrin: NSLayoutConstraint!
    @IBOutlet weak var imageViewRiderProfile                        : UIImageView!
    @IBOutlet weak var CMStar                                       : CosmosView!
    @IBOutlet weak var textFiledRideStatus                          : UITextField!
  
    @IBOutlet weak var labelDriverName                              : UILabel!
    @IBOutlet weak var buttonSubmit                                 : UIButton!
    @IBOutlet weak var viewSubmitButton                             : UIView!
    var driverId                                                    : Int!
    var tripID                                                      : Int!
    var rating                                                      : Int!
    var ratingView                                                  = CosmosView()
    override func viewDidLoad() {
        super.viewDidLoad()
        rating = Int(5)
        viewSubmitButton.layer.cornerRadius = 5.0
        buttonSubmit.layer.cornerRadius = 8.0
        viewSubmitButton.layer.borderWidth = 1.0
        textFiledRideStatus.layer.cornerRadius = 8.0
        textFiledRideStatus.layer.borderWidth = 1.0
        textFiledRideStatus.layer.borderColor = UIColor.lightGray.cgColor
        viewSubmitButton.layer.borderColor = UIColor.clear.cgColor
        viewSubmitButton.layer.masksToBounds = true
        self.setupUI()
        self.getDriverDetails()
      
        
        CMStar.didFinishTouchingCosmos = { ratingValue in
            self.rating = Int(ratingValue)
            print(self.rating)
            
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(keyBoadrdHide))
        self.view.addGestureRecognizer(tapGesture)
        
    }
   
    func setupUI()  {
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 10, width: self.view.frame.width, height: 50.0)
        let btn1 = UIButton(type: .custom)
        //btn1.setImage(UIImage(named: "Notification_button_3x"), for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
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
        
        
        self.navigationItem.title = "Rating"
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.red]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        
        self.imageViewRiderProfile.layer.cornerRadius = 8.0
    }
    //MARK:- Toggle SideMenu
    @objc func sideMenuAction() {
       // menuContainerViewController.toggleLeftSideMenuCompletion(nil)
        self.navigationController?.popViewController(animated: true)
    }
    @objc func notificationAction() {
        
    }
    @IBAction func buttonSubmitAction(_ sender: UIButton) {
        
        if textFiledRideStatus.text?.isEmpty == false {
            self.rateDriver()
        }else{
            GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Please fill the fields")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: Api add reting to driver
    func rateDriver(){
            let hud = GenericFunctions.showJHud(target: self)
        AlamofireSubclass.parseLinkUsingPostMethod("ride/add_rating", with: ["driver_id":String(driverId!),"trip_id": String(tripID!), "user_id": String(User.current.user_details!.u_id!), "rating_score":String(rating!),"review":self.textFiledRideStatus.text!]) { (success, response, error) in
            hud.hide()
            if success == true
            {
                if response!["message"] as! String == "Rating added successfully" {
                    let alert = UIAlertController(title: "Message", message: "Rating Successfull", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction((UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in
                        DispatchQueue.main.async {
                            for controller in self.navigationController!.viewControllers as Array {
                                if controller.isKind(of: EnterDestinationViewController.self) {
                                    self.navigationController!.popToViewController(controller, animated: true)
                                    break
                                }
                            }
                        }
                    })))
                    self.present(alert, animated: true, completion: nil)
                }else{
                    GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Rating failed")
                }
                
            }else{
                GenericFunctions.showAlertView(targetVC: self, title: "Message", message: (error?.localizedDescription)!)
            }
        }
    }
    //MARK: get driver details
    func getDriverDetails(){
        let hud = GenericFunctions.showJHud(target: self)
        AlamofireSubclass.parseLinkUsingGetMethod("view/details/driver/\(String(driverId!))") { (success, response, error) in
            hud.hide()
            if success == true {
                if response!["message"] as! String == "Driver detais" {
                    let driverDetails = response!["data"] as! NSDictionary
                    let driver = driverDetails["user_details"] as! NSDictionary
                    self.labelDriverName.text = driver["first_name"] as? String
                    let imageUrl = driverDetails["user_pic_url"] as! String
                    self.imageViewRiderProfile.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "dummy") , options: .highPriority) { (image, error, cache, url) in
                        //
                    }
                }
                else {
                    GenericFunctions.showAlertView(targetVC: self, title: "Error", message: "Please try again")
                }
                
            }else{
                GenericFunctions.showAlertView(targetVC: self, title: "Error", message: (error?.localizedDescription)!)
            }
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.bottomConstrin.constant = -100.0
    }
   /* func textFieldDidEndEditing(_ textField: UITextField) {
        self.bottomConstrin.constant = 40.0
        textFiledRideStatus.resignFirstResponder()
     
     
    }*/
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.bottomConstrin.constant = 15.0
        textFiledRideStatus.resignFirstResponder()
        return true
    }
    @objc func keyBoadrdHide()  {
        textFiledRideStatus.resignFirstResponder()
        self.bottomConstrin.constant = 15.0
    }

}
