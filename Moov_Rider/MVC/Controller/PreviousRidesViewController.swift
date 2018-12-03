//
//  PreviousRidesViewController.swift
//  Moov_Rider
//
//  Created by Visakh on 21/07/18.
//  Copyright © 2018 Visakh. All rights reserved.
//

import UIKit
import SDWebImage

class PreviousRidesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var CMStar                                       : CosmosView!

    @IBOutlet weak var tableViewRideDetails: UITableView!
    @IBOutlet weak var imageViewDriverProfile                       : UIImageView!
    @IBOutlet weak var buttonCancelRide                             : UIButton!
    @IBOutlet weak var viewDriverDetails                            : UIView!
    @IBOutlet weak var labelDriverName                              : UILabel!
    @IBOutlet weak var labelCarName                                 : UILabel!
    @IBOutlet weak var labelPhoneNumber                             : UILabel!
    @IBOutlet weak var labelDistance                                : UILabel!
    @IBOutlet weak var labelETA                                     : UILabel!
    @IBOutlet weak var labelPlateNumber                             : UILabel!
    var driverID                                                    = Int()
    var rating                                                      : Double!
    var ratingView                                                  = CosmosView()
    var tripID                                                      = Double()
    var arrayCurrentRideDetails                                     = NSArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.userCurrentRides()
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationSend), name: NSNotification.Name(rawValue: "didReceiveRemoteNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notificationStopRide), name: NSNotification.Name(rawValue: "didReceiveRemoteNotificationforstopride"), object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.userCurrentRides()
    }
    func setupUI() {
        
        
        let btnMenu = UIButton(type: .custom)
        btnMenu.setImage(#imageLiteral(resourceName: "Back_Button_3x"), for: .normal)
        btnMenu.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        btnMenu.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        let item3 = UIBarButtonItem(customView: btnMenu)
        self.navigationItem.setLeftBarButton(item3, animated: true)
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
        
        self.navigationItem.title = "Moov"
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.red]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
    }
   
    //MARK:- API User current ride
    func userCurrentRides(){
        let hud = GenericFunctions.showJHud(target: self)
        AlamofireSubclass.parseLinkUsingGetMethod("view/rides/current/user/\(User.current.user_details!.u_id!)") { (success, response, error) in
            hud.hide()
            if success == true{
                if response!["message"] as! String == "Rides Lists" {
                    self.arrayCurrentRideDetails = response!["data"] as! NSArray
                    self.tableViewRideDetails.reloadData()
                   
                }else{
                    GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "No rides found")
                }
            }else{
                GenericFunctions.showAlertView(targetVC: self, title: "Messgae", message: (error?.localizedDescription)!)
            }
        }
    }
    
    
    @IBAction func buttonCancelRideTouched(_ sender: UIButton) {
        let data = arrayCurrentRideDetails[sender.tag] as! NSDictionary
        print(data)
        let tripID = String(data["ride_id"] as! Int)
        self.cancelRide(tripId: tripID)
    }
    //MARK:- Cancel Ride
    func cancelRide(tripId:String!)  {
        let hud = GenericFunctions.showJHud(target: self)
        AlamofireSubclass.parseLinkUsingGetMethod("rides/cancel/\(tripId!)/free") { (success, response, error) in
            hud.hide()
            if success == true{
                if response!["message"] as! String == "Ride cancelled"{
                    let alert = UIAlertController(title: "Message", message: "Successfully cancel your ride", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction((UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in
                        self.userCurrentRides()
                    })))
                    self.present(alert, animated: true, completion: nil)
                }else{
                    GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "An error occured")
                }
                
            }else{
                GenericFunctions.showAlertView(targetVC: self, title: "Message", message: (error?.localizedDescription)!)
            }
        }
    }
    
    //MARK:- Toggle SideMenu
    @objc func backButtonAction() {
        //self.navigationController?.popViewController(animated: true)
        menuContainerViewController.toggleLeftSideMenuCompletion(nil)
    }
    @objc func notificationAction() {
        
        let walletVc = self.storyboard?.instantiateViewController(withIdentifier: "MyWalletViewController") as! MyWalletViewController
        self.navigationController?.pushViewController(walletVc, animated: true)
    }
    //MARK:- Tableview delegates and datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayCurrentRideDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PreviousRides", for: indexPath) as! PreviousRidesTableViewCell
        cell.buttonCancelRide.tag = indexPath.row
        let dict = arrayCurrentRideDetails[indexPath.row] as! NSDictionary
        let driverDetailsDict = dict["driver_details"] as! NSDictionary
        let driveDict = dict["drive_detais"] as! NSDictionary
        
        let imageUrl = driverDetailsDict["image"] as? String
        cell.imageViewProfile.sd_setImage(with: URL(string: imageUrl!), placeholderImage: #imageLiteral(resourceName: "dummy") , options: .highPriority) { (image, error, cache, url) in
            //
        }
        cell.labelCarName.text = driverDetailsDict["car_model"] as? String
        cell.labelDistance.text = driveDict["distance"] as? String
        cell.labelPhoneNumber.text = driverDetailsDict["phone"] as? String
        cell.labelETA.text = driveDict["time"] as? String
        cell.labelPlateNumber.text = driverDetailsDict["vehicle_no"] as? String
        cell.labelDriverName.text = "\(String(describing: driverDetailsDict["first_name"] as! String)) \(String(describing: driverDetailsDict["last_name"] as! String))"
        
        cell.cmStar.rating = driverDetailsDict["ratings"] as! Double
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK :- Notification Start Ride
    @objc func notificationSend(userInfo : NSNotification){
            self.buttonCancelRide.isHidden = true
    }
    //MARK :- Notification Stop ride
    @objc func notificationStopRide(){
            //self.viewDriverDetails.isHidden = true
    
    }


}
