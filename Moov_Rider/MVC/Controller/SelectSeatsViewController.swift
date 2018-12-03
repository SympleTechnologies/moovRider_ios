//
//  SelectSeatsViewController.swift
//  Moov_Rider
//
//  Created by Visakh on 18/07/18.
//  Copyright © 2018 Visakh. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import GooglePlaces
import Firebase


class SelectSeatsViewController: UIViewController, NIDropDownDelegate, CLLocationManagerDelegate,UITextFieldDelegate, GooglePlacesDelegate {

    @IBOutlet weak var imageViewDriverProfile       : UIImageView!
    @IBOutlet weak var buttonCancelRide             : UIButton!
    @IBOutlet weak var viewDriverDetails            : UIView!
    @IBOutlet weak var buttonMoov                   : UIButton!
    @IBOutlet weak var buttonSelectSeats            : UIButton!
    @IBOutlet weak var viewNoOfSeats                : UIView!
    @IBOutlet weak var viewWarning                  : UIView!
    @IBOutlet weak var buttonAlert                  : UIButton!
    @IBOutlet weak var labelAmount                  : UILabel!
    @IBOutlet weak var textFieldNoofSeats           : UITextField!
    @IBOutlet weak var textFileUniversity           : UITextField!
    @IBOutlet weak var textFieldEnterDestination    : UITextField!
    @IBOutlet weak var textFieldEnterYourLocation   : UITextField!
    @IBOutlet weak var labelNoOfTrips               : UILabel!
    @IBOutlet weak var labelNoOfSeats               : UILabel!
    @IBOutlet weak var viewDetails: UIView!
    @IBOutlet weak var buttonScheduleARide: UIButton!
    var previousDropBtn                             : UIButton!
    var isDropDownOpen                              = Bool()
    var nidropDown                                  = NIDropDown()
    var dropdownArr                                 = NSArray()
    var Destination                                 : String!
    var Location                                    : String!
    var amount                                      : Double!
    var arrayCollegeNameList                        : NSMutableArray!
    var arrayCollegeList                            : [College]!
    var selectPool                                  : String!
    var selectUniversity                            = Bool()
    var walletBalance                               : String!
    var currentCollegeName                          : String!
    var collegeID                                   : Int!
    var locationManager                             = CLLocationManager()
    var userCurentLoaction                          = CLLocationCoordinate2D()
    var arrayPlaces                                 = NSMutableArray()
    var arrayPlacesName                             = NSMutableArray()
    var dropdown                                    : BMGooglePlaces!
    var activeTextField                             : UITextField!
    var driverObj                                   : DriverDetails?
    var deviceToken                                 : String!
    @IBOutlet weak var labelDriverName              : UILabel!
    @IBOutlet weak var labelCarName                 : UILabel!
    @IBOutlet weak var labelPhoneNumber             : UILabel!
    @IBOutlet weak var labelDistance                : UILabel!
    @IBOutlet weak var labelPlateNumber             : UILabel!
    @IBOutlet weak var labelEta                     : UILabel!
    @IBOutlet weak var CMStar                       : CosmosView!
    var rating                                      : Int!
    var ratingView                                  = CosmosView()
    var driverID                                    : Int!
    var tripID                                      : Int!
   // var mapView                                     :GMSMapView?
    
    var currentLocation                             : CLLocation?
    var placesClient                                : GMSPlacesClient!
    var zoomLevel                                   : Float = 50.0
    var camera                                      : GMSCameraPosition!
    var likelyPlaces: [GMSPlace] = []
    
    var selectedPlace                               : GMSPlace?
    let marker                                      = GMSMarker()
    var strr                                        = [String]()
    var markerStart                                 = GMSMarker()
    var markerEnd                                   = GMSMarker()
    var firebaseHandle                              : DatabaseHandle!
    var geoFire                                     : GeoFire!
    let geofireRef                                  = Database.database().reference()
    var regionQuery                                 : GFRegionQuery?
    var vehicleMarker                               : VehicleMarker!
    @IBOutlet weak var mapView                      : GMSMapView!
    var oldAngle                                    : Double?
    var ridercoordinate                             : CLLocation!
    var finishmarker                                : GMSMarker!
    var fromCoordinate                              : CLLocationCoordinate2D!
    var destCoordinate                              : CLLocationCoordinate2D!
    
    var sourceLatt                                  : Double!
    var sourceLong                                  : Double!
    var DestinationLatt                             : Double!
    var DestinationLong                             : Double!
    
    var expectedTime                                 = Int()
    var arrayDistance                                = NSArray()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         self.viewDetails.isHidden = false
        self.userCurrentCollege()
        dropdownArr = ["1","2","3","4","5","6","7"]
        nidropDown.delegate = self
        self.setupUI()
        self.viewDriverDetails.isHidden = true
        self.listColleges()
        self.showWalletBalance()
        labelAmount.text = String(amount)
       
        
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            locationManager.distanceFilter = 50
        } else {
            print("Location services are not enabled");
        }
         NotificationCenter.default.addObserver(self, selector: #selector(notificationSend(userInfo:)), name: NSNotification.Name(rawValue: "didReceiveRemoteNotification"), object: nil)
        
         //NotificationCenter.default.addObserver(self, selector: #selector(notificationStopRide), name: NSNotification.Name(rawValue: "didReceiveRemoteNotificationforstopride"), object: nil)
        
        placesClient = GMSPlacesClient.shared()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.buttonMoov.isUserInteractionEnabled = true
        textFieldEnterDestination.text = Destination
        textFieldEnterYourLocation.text = Location
        self.showWalletBalance()
        
    }
    func setupUI()  {
        self.textFieldEnterDestination.layer.cornerRadius = 8.0
        self.textFieldEnterDestination.layer.masksToBounds = true
        self.textFieldEnterYourLocation.layer.cornerRadius = 8.0
        self.textFieldEnterYourLocation.layer.masksToBounds = true
        self.textFieldEnterDestination.layer.borderWidth = 1.0
        self.textFieldEnterDestination.layer.borderColor = UIColor.lightGray.cgColor
        self.textFieldEnterYourLocation.layer.borderWidth = 1.0
        self.textFieldEnterYourLocation.layer.borderColor = UIColor.lightGray.cgColor
        self.textFileUniversity.layer.borderWidth = 1.0
        self.textFileUniversity.layer.borderColor = UIColor.lightGray.cgColor
        self.textFileUniversity.layer.cornerRadius = 8.0
        self.textFileUniversity.layer.masksToBounds = true
        
        
        
        self.viewWarning.layer.borderWidth = 1.0
        self.viewWarning.layer.borderColor = UIColor.lightGray.cgColor
        self.viewWarning.layer.cornerRadius = 8.0
        self.viewWarning.layer.masksToBounds = true
        
        self.labelNoOfSeats.layer.borderWidth = 1.0
        self.labelNoOfSeats.layer.borderColor = UIColor.lightGray.cgColor
        self.labelNoOfSeats.layer.cornerRadius = 8.0
        self.labelNoOfSeats.layer.masksToBounds = true
        
        self.buttonSelectSeats.layer.borderWidth = 1.0
        self.buttonSelectSeats.layer.borderColor = UIColor.lightGray.cgColor
        self.buttonSelectSeats.layer.cornerRadius = 8.0
        self.buttonSelectSeats.layer.masksToBounds = true
        
        self.buttonMoov.layer.borderWidth = 1.0
        self.buttonMoov.layer.borderColor = UIColor.lightGray.cgColor
        self.buttonMoov.layer.cornerRadius = 8.0
        self.buttonMoov.layer.masksToBounds = true
        
        
        textFieldEnterDestination.leftViewMode = .always
        let imageView = UIImageView(frame:CGRect(x: 0, y: 0, width: 35, height: 35))
        imageView.image = #imageLiteral(resourceName: "map pointer")
        let paddingView = UIView(frame:CGRect(x: 0, y: 0, width: 40, height: textFieldEnterDestination.frame.height))
        let paddingViewV = UIView(frame:CGRect(x: 0, y: 0, width: 40, height: textFieldEnterDestination.frame.height))
        imageView.center = paddingView.center
        paddingView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        paddingViewV.addSubview(paddingView)
        paddingViewV.backgroundColor = UIColor.clear
        textFieldEnterDestination.leftView = paddingViewV
        
        
        textFieldEnterYourLocation.leftViewMode = .always
        let imageView1 = UIImageView(frame:CGRect(x: 0, y: 0, width: 35, height: 35))
        imageView1.image = #imageLiteral(resourceName: "map yellow pointer")
        let paddingView1 = UIView(frame:CGRect(x: 0, y: 0, width: 40, height: textFieldEnterYourLocation.frame.height))
        let paddingViewW = UIView(frame:CGRect(x: 0, y: 0, width: 40, height: textFieldEnterYourLocation.frame.height))
        imageView1.center = paddingView1.center
        paddingView1.addSubview(imageView1)
        imageView1.contentMode = .scaleAspectFit
        paddingViewW.addSubview(paddingView1)
        paddingViewW.backgroundColor = UIColor.clear
        textFieldEnterYourLocation.leftView = paddingViewW
        
        viewDriverDetails.layer.cornerRadius = 10.0
        viewDriverDetails.layer.borderColor = UIColor.lightGray.cgColor
        viewDriverDetails.layer.borderWidth = 0.5
        viewDriverDetails.layer.masksToBounds = true
        imageViewDriverProfile.layer.cornerRadius = 10.0
        imageViewDriverProfile.layer.masksToBounds = true
        buttonCancelRide.layer.cornerRadius = 5.0
        buttonCancelRide.layer.masksToBounds = true
        buttonAlert.isHidden = true
        
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 10, width: self.view.frame.width, height: 50.0)
        let btnMenu = UIButton(type: .custom)
        btnMenu.setImage(#imageLiteral(resourceName: "Back_Button_3x"), for: .normal)
        btnMenu.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        btnMenu.addTarget(self, action: #selector(sideMenuAction), for: .touchUpInside)
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
    //MARK: walletBalance
    func showWalletBalance() {
        let hud = GenericFunctions.showJHud(target: self)
        AlamofireSubclass.parseLinkUsingGetMethod("wallet/balance/\(User.current.user_details!.u_id!)") { (success, response, error) in
            hud.hide()
            if success == true {
                self.walletBalance = String(describing: (response!["wallet_balance"] as! Double))
                let balance = Float(self.walletBalance!)
                if balance! < Float(self.amount!) {
                    self.buttonAlert.isHidden = false
                    self.buttonMoov.setTitle("Recharge", for: .normal)
                }else{
                    self.buttonAlert.isHidden = true
                    self.buttonMoov.setTitle("MOOV", for: .normal)
                }
            }else{
                GenericFunctions.showAlertView(targetVC: self, title: "Error", message: (error?.localizedDescription)!)
                self.walletBalance = String(0)
            }
        }
    }
    
    //MARK: Api List Colleges
    func listColleges() {
        AlamofireSubclass.parseLinkUsingGetMethod("auth/select_college") { (success, response, error) in
            if success == true {
                self.arrayCollegeList = [College]()
                self.arrayCollegeNameList = NSMutableArray()
                if response!["message"] as! String == "College List" {
                    let dataDict = response!["data"] as! NSDictionary
                    for dict in dataDict["details"] as! NSArray {
                        let objClg = College().initWith((dict as! NSDictionary))
                        self.arrayCollegeList.append(objClg)
                        self.arrayCollegeNameList.add(objClg.name)
                    }
                   let item = self.arrayCollegeList.filter { $0.id == self.collegeID! }.first
                    self.textFileUniversity.text = item != nil ? item!.name : "School"
                }else {
                    GenericFunctions.showAlertView(targetVC: self, title: "Error", message: "Please try again")
                }
                
            }else{
                GenericFunctions.showAlertView(targetVC: self, title: "Error", message: (error?.localizedDescription)!)
            }
        }
    }
    //MARK: Api User Current Colleges
    func userCurrentCollege() {
        let hud = GenericFunctions.showJHud(target: self)
        AlamofireSubclass.parseLinkUsingGetMethod("ride/view_colleges/\(String(describing: User.current.user_details!.u_id!))") { (success, response, error) in
            hud.hide()
            if success == true {
                    let userInstituteId = (response!["data"] as! NSDictionary)["user_institute"] as! Int
                   // self.listColleges()
                    //self.currentCollegeName = (self.arrayCollegeNameList[userInstituteId] as! String)
            }else{
                GenericFunctions.showAlertView(targetVC: self, title: "Error", message: (error?.localizedDescription)!)
            }
        }
    }
    
    //MARK:- Api
    func chooseDestination()
    {
        let src = textFieldEnterDestination.text?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let dest = textFieldEnterYourLocation.text?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let numberOfSeats = textFieldNoofSeats.text
        let hud = GenericFunctions.showJHud(target: self)
        AlamofireSubclass.parseLinkUsingGetMethod("ride/search/amount/\(src!)/\(dest!)/\(String(describing: numberOfSeats!))/\(selectPool!)") { (success, response, error) in
            hud.hide()
            if success == true {
                if response!["message"] as! String == "Amount calculated" {
                    
                    let data = response!["data"] as! NSDictionary
                   let amount = data["amount"] as! Double
                    self.labelAmount.text = String(amount)
                    
                }else {
                    GenericFunctions.showAlertView(targetVC: self, title: "Error", message: "Please try again")
                }
            }else{
                GenericFunctions.showAlertView(targetVC: self, title: "Error", message: (error?.localizedDescription)!)
            }
        }
    }

    @objc func sideMenuAction() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func notificationAction() {
        let walletVc = self.storyboard?.instantiateViewController(withIdentifier: "MyWalletViewController") as! MyWalletViewController
        self.navigationController?.pushViewController(walletVc, animated: true)
    }
    //MARK:- Dropdown delegate
    func niDropDownDelegateMethod(_ sender: UIButton!, selectedIndex index: Int32) {
       
        if selectUniversity == true {
           self.textFieldNoofSeats.text = (dropdownArr[Int(index)] as! String)
            
            chooseDestination()
        }else{
            self.textFileUniversity.text = (arrayCollegeNameList[Int(index)] as! String)
            collegeID = arrayCollegeList[Int(index)].id
        }
        self.buttonMoov.isUserInteractionEnabled = true
        self.buttonScheduleARide.isUserInteractionEnabled = true
        nidropDown.hide(previousDropBtn)
        nidropDown.removeFromSuperview()
        
    }
    //MARK:- Button Actions
    @IBAction func buttonSelectNoOfSeats(_ sender: UIButton) {
        sender.isSelected   = !sender.isSelected
        self.buttonMoov.isUserInteractionEnabled = false
        self.buttonScheduleARide.isUserInteractionEnabled = false
        selectUniversity = true
        if isDropDownOpen == true {
            nidropDown.hide(previousDropBtn)
            if previousDropBtn != sender {
                previousDropBtn.isSelected = !previousDropBtn.isSelected
            }
            isDropDownOpen = false
        }
        if sender.isSelected == true {
            nidropDown.show(sender,120.0, dropdownArr as! [Any], nil, "down")
            //(sender, 120.0 , , nil, "down")
            isDropDownOpen = true
        }else {
            nidropDown.hide(sender)
        }
        previousDropBtn = sender
    }
    @IBAction func buttonSelectUniversityAction(_ sender: UIButton) {
        
        sender.isSelected   = !sender.isSelected
        selectUniversity = false
        if isDropDownOpen == true {
            nidropDown.hide(previousDropBtn)
            if previousDropBtn != sender {
                previousDropBtn.isSelected = !previousDropBtn.isSelected
            }
            isDropDownOpen = false
        }
        if sender.isSelected == true {
            nidropDown.show(sender,120.0, arrayCollegeNameList as! [Any], nil, "down")
            //(sender, 120.0 , , nil, "down")
            isDropDownOpen = true
        }else {
            nidropDown.hide(sender)
        }
        previousDropBtn = sender
        
    }
    @IBAction func buttonMoovAction(_ sender: UIButton) {
        
        let balance = Float(self.walletBalance)
        if balance! < Float(self.amount) {
            let walletVc = self.storyboard?.instantiateViewController(withIdentifier: "MyWalletViewController") as! MyWalletViewController
            walletVc.pageID = "Recharge"
            self.navigationController?.pushViewController(walletVc, animated: true)
           // self.bookLiveRide()
            
        }else{
            if textFieldEnterDestination.text?.isEmpty == false{
                if textFieldEnterYourLocation.text?.isEmpty == false{
                    if textFieldEnterDestination.text == textFieldEnterYourLocation.text {
                        GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Choose another location")
                    }else{
                        self.bookLiveRide()
                    }
                }else{
                    GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Please fill all the fields")
                }
            }else{
                GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Please fill all the fields")
            }
        }
    }
    @IBAction func buttonBookFutureBookAction(_ sender: UIButton) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let popupVC = storyboard.instantiateViewController(withIdentifier: "FutureBookingViewController") as! FutureBookingViewController
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        popupVC.amount = self.amount
        popupVC.collegeID = self.collegeID
        popupVC.Destination = self.Destination!
        popupVC.Location = self.Location!
        popupVC.selectPool = self.selectPool!
        popupVC.fromCoordinate = self.fromCoordinate
        popupVC.destCoordinate = self.destCoordinate
        popupVC.userCurentLoaction = self.userCurentLoaction
       // popupVC.preferredContentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
        let pVC = popupVC.popoverPresentationController
        pVC?.permittedArrowDirections = .any
        pVC?.sourceView = sender
       // pVC?.sourceRect = CGRect(x: 50, y: 50, width: 1, height: 1)
        let navController = UINavigationController(rootViewController: popupVC)
        present(navController, animated: true, completion: nil)
        
    }
    
    // MARK:- Api Book live a ride
    func bookLiveRide()  {
        var params  : NSDictionary?
        let src = textFieldEnterYourLocation.text?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let dest = textFieldEnterDestination.text?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        // fromCoordinate = self.geoCode(usingAddress: textFieldEnterYourLocation.text!)
        let fromLat = String(fromCoordinate.latitude)
        let fromLong = String(fromCoordinate.longitude)
         //destCordinate = self.geoCode(usingAddress: textFieldEnterDestination.text!)
        let destLat = String(destCoordinate.latitude)
        let destLong = String(destCoordinate.longitude)
        
        params = ["userid": String(User.current.user_details!.u_id!), "from": src!, "from_lat":fromLat, "from_long":fromLong, "to": dest! ,"to_lat":destLat, "to_long":destLong, "pooling":selectPool!, "seats":textFieldNoofSeats.text!, "collegeid": String(collegeID!), "amount": String(amount!), "current_lat":String(userCurentLoaction.latitude), "current_long":String(userCurentLoaction.longitude)]
        
        let hud = GenericFunctions.showJHud(target: self)
        AlamofireSubclass.parseLinkUsingPostMethod("ride/book_now", with: params!) { (success, response, error) in
            hud.hide()
            if success == true{
                if response!["status"] as! Bool == true{
                    
                    for controller in self.navigationController!.viewControllers as Array {
                        if controller.isKind(of: EnterDestinationViewController.self) {
                            self.navigationController!.popToViewController(controller, animated: true)
                            break
                        }
                    }
                    
                    
                   /* let data = response!["data"] as! NSDictionary
                    let driverDetails = data["driver_details"] as! NSDictionary
                    let rideDetails = data["distance_to_drive_details"] as! NSDictionary
                    self.driverObj = DriverDetails().initWith(dictionary: data)
                    self.viewDriverDetails.isHidden = false
                    self.buttonCancelRide.isHidden = false
                   /* self.labelDriverName.text = DriverDetails.init().first_name
                    self.labelCarName.text = DriverDetails.init().car_model
                    self.labelPhoneNumber.text = DriverDetails.init().phone
                    self.labelDistance.text = DriverDetails.init().distance_to_drive_details.distance
                    self.labelPlateNumber.text = DriverDetails.init().vehicle_no
                    self.labelEta.text = DriverDetails.init().distance_to_drive_details.time*/
                    self.labelDriverName.text = driverDetails["first_name"] as? String
                    self.labelCarName.text = driverDetails["car_model"] as? String
                    self.labelPhoneNumber.text = driverDetails["phone"] as? String
                    self.labelDistance.text = rideDetails["distance"] as? String
                    self.labelPlateNumber.text = driverDetails["vehicle_no"] as? String
                    self.labelEta.text = rideDetails["time"] as? String
                    let imageUrl = driverDetails["image"] as? String
                    self.labelNoOfTrips.text = String(driverDetails["total_rides"] as! Int)
                    self.imageViewDriverProfile.sd_setImage(with: URL(string: imageUrl!), placeholderImage: #imageLiteral(resourceName: "dummy") , options: .highPriority) { (image, error, cache, url) in
                        //
                   }
                    self.driverID = driverDetails["driver_id"] as! Int
                    self.tripID = data["trip_id"] as! Int
                    let rating = driverDetails["ratings"] as? Double
                    self.CMStar.rating = rating!
                    let polyLine = response!["poly_line"] as! String
                    let path = GMSPath.init(fromEncodedPath: polyLine)
                                        let polyline = GMSPolyline(path: path)
                    polyline.strokeColor = .blue
                    polyline.strokeWidth = 3.0
                    polyline.map = self.mapView
                    self.actionStartRide(driverID : self.driverID)
                    
                    let coordinates = response!["poly_lines"] as! NSDictionary
                    let startCoordinates = coordinates["start"] as! NSDictionary
                    let EndCoordinates = coordinates["end"] as! NSDictionary
                    
                    let startLat = startCoordinates["lat"] as! Double
                    let startLong = startCoordinates["lng"] as! Double
                    let EndLat = EndCoordinates["lat"] as! Double
                    let EndLong = EndCoordinates["lng"] as! Double
                    
                    let position = CLLocationCoordinate2DMake(startLat,startLong)
                     self.markerStart = GMSMarker(position: position)
                    self.markerStart.icon = GMSMarker.markerImage(with: UIColor.green)
                    self.markerStart.map = self.mapView
                    
                    let positionEnd = CLLocationCoordinate2DMake(EndLat,EndLong)
                    self.markerEnd = GMSMarker(position: positionEnd)
                    self.markerEnd.icon = GMSMarker.markerImage(with: UIColor.red)
                    self.markerEnd.map = self.mapView
                  //self.buttonMoov.isUserInteractionEnabled = false
                    self.viewDetails.isHidden = true
                    
                    
                    */
                    
                   
                    
                    let fromCordLat = self.fromCoordinate.latitude
                    let fromCordLong = self.fromCoordinate.longitude
                    let fromCordDict = ["lat": fromCordLat, "long": fromCordLong]
                    
                     let fromCoordinatesData : NSData = NSKeyedArchiver.archivedData(withRootObject: fromCordDict) as NSData
                     UserDefaults.standard.set(fromCoordinatesData, forKey: "fromCoordinates")
                   // UserDefaults.standard.set(fromCordDict, forKey: "fromCoordinates")
                    UserDefaults.standard.synchronize()
                    
                    
                }else{
                    GenericFunctions.showAlertView(targetVC: self, title: "Message", message: response!["message"] as! String)
                }
            }else{
                GenericFunctions.showAlertView(targetVC: self, title: "Message", message: (error?.localizedDescription)!)
            }
        }
    }
    
    // MARK: - CoreLocation Delegate Methods
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        if ((error) != nil) {
            print(error)
        }
    }
    
    func  locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        var locationArray = locations as NSArray
        let locationObj = locationArray.lastObject as! CLLocation
        var coord = locationObj.coordinate
        userCurentLoaction = locationObj.coordinate

        currentLocation = locations.last!
        let point = mapView.projection.point(for: (self.currentLocation?.coordinate)!)
        let camera : GMSCameraUpdate!
        mapView.isMyLocationEnabled = true
        camera = GMSCameraUpdate.setTarget(mapView.projection.coordinate(for: point), zoom: 12.0)
        mapView.animate(with: camera)

    }
    //MARK:- get location from string
    func getLocationFromAddressString(_ placeId: String) -> CLLocationCoordinate2D {
        var latitude: Double = 0
        var longitude: Double = 0
        var center = CLLocationCoordinate2D()
        let esc_addr: String? = placeId.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let req = "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(String(describing: esc_addr!))&key=AIzaSyDpEOdHfWlmp5nmCak91Xxfdw6rvUQXn50"
        let result = try? String(contentsOf: URL(string: req)!, encoding: .utf8)
        if result != nil {
            let scanner = Scanner(string: result ?? "")
            if scanner.scanUpTo("\"lat\" :", into: nil) && scanner.scanString("\"lat\" :", into: nil) {
                scanner.scanDouble(&latitude)
                if scanner.scanUpTo("\"lng\" :", into: nil) && scanner.scanString("\"lng\" :", into: nil) {
                    scanner.scanDouble(&longitude)
                    center.latitude = latitude
                    center.longitude = longitude
                }
            }
        }
        return center
    }
    
    
    
  
    func fetchLocations(WithCompletion: @escaping ( _ success:Bool, _ arrayResult:NSArray)->Void)
    {
        let searchQuery:SPGooglePlacesAutocompleteQuery = SPGooglePlacesAutocompleteQuery()
        searchQuery.input = activeTextField.text
        searchQuery.fetchPlaces { (places, error) -> Void in
            if(error == nil){
                let arraytempPlaces:NSArray = places as AnyObject as! NSArray
                if(arraytempPlaces.count > 0){
                    self.arrayPlaces.removeAllObjects()
                    for item in arraytempPlaces{
                        let googlepLaces = item as! SPGooglePlacesAutocompletePlace
                        self.arrayPlaces.add(googlepLaces)
                        self.arrayPlacesName.add(googlepLaces.name)
                    }
                    WithCompletion(true,self.arrayPlaces)
                }
            }
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        self.activeTextField = textField
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        self.fetchLocations { (success, arrayResult) in
            if(self.dropdown == nil){
                self.dropdown = BMGooglePlaces(frame:CGRect(x:self.activeTextField.frame.origin.x, y:self.activeTextField.frame.maxY + 10, width : self.activeTextField.frame.width, height : 90))
                self.dropdown?.delegate = self
                self.dropdown.isGooglePlacesData = true
                self.dropdown!.arrayToLoad = self.arrayPlaces.mutableCopy() as! NSMutableArray
                self.activeTextField.superview!.addSubview(self.dropdown!)
            }else{
                self.dropdown.reload(self.arrayPlaces as! [Any])
            }
        }
        return true
    }
    func selectedPlace(_ place: NSObject!) {
        let selecetedPlace = place as! SPGooglePlacesAutocompletePlace
        if self.activeTextField.tag == 20
        {
            self.textFieldEnterDestination.text = selecetedPlace.name
           self.destCoordinate = self.getLocationFromAddressString(selecetedPlace.placeId)

            textFieldEnterDestination.resignFirstResponder()
            chooseDestination()
        }
        else if activeTextField.tag == 30
        {
            self.textFieldEnterYourLocation.text = selecetedPlace.name
             self.fromCoordinate = self.getLocationFromAddressString(selecetedPlace.placeId)
           
            textFieldEnterYourLocation.resignFirstResponder()
            chooseDestination()
        }
        self.dropdown = nil
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.textFieldEnterDestination.resignFirstResponder()
        self.textFieldEnterYourLocation.resignFirstResponder()
        
        return true
    }
    @IBAction func buttonCancelRideAction(_ sender: UIButton) {
        self.calculateDistance()
       
    }
    //MARK: API RidePAy
    func ridePay()  {
        let hud = GenericFunctions.showJHud(target: self)
        AlamofireSubclass.parseLinkUsingPostMethod("rides/pay", with: ["userid":String(User.current.user_details!.u_id),"ride_id":"","amount": ""]) { (success, response, error) in
            hud.hide()
            if success  == true {
                if response!["message"] as! String == "paid successfully"
                {
                    GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Success")
                    
                }else{
                    GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Please try again")
                }
            }else{
                GenericFunctions.showAlertView(targetVC: self, title: "Message", message: (error?.localizedDescription)!)
            }
        }
    }
    //MARK:- API Cancel Ride
    func cancelRide(cancelType : String!) {
        if driverObj != nil {
            let hud = GenericFunctions.showJHud(target: self)
            // let driverId  = String(driverObj!.driver_id!)
            let rideId = String(driverObj!.ride_id!)
            AlamofireSubclass.parseLinkUsingGetMethod("rides/cancel/\(rideId)/\(cancelType!)") { (success, response, error) in
                hud.hide()
                if success == true{
                    if response!["message"] as! String == "Ride cancelled"{
                        let alert = UIAlertController(title: "Message", message: "Successfully cancel your ride", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction((UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in
                            DispatchQueue.main.async {
                                self.navigationController?.popViewController(animated: true)
                            }
                        })))
                       
                        self.present(alert, animated: true, completion: nil)
                        self.viewDetails.isHidden = false
                        
                    }else{
                        GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Please try again")
                    }
                    
                }else{
                    GenericFunctions.showAlertView(targetVC: self, title: "Message", message: (error?.localizedDescription)!)
                }
            }
        }
    }
    
   
    //MARK :- Notification Start Ride
    @objc func notificationSend(userInfo : NSNotification){
        if viewDriverDetails.isHidden == false{
            UserDefaults.standard.set(true, forKey: "status")
            self.buttonCancelRide.isHidden = true
        }
    }
    //MARK :- Notification Stop ride
   /* @objc func notificationStopRide(){
        if viewDriverDetails.isHidden == false{
            self.viewDriverDetails.isHidden = true
            //let rateDriverVC = self.storyboard?.instantiateViewController(withIdentifier: "RateDriverViewController") as! RateDriverViewController
           // rateDriverVC.driverId = driverID
           // rateDriverVC.tripID = tripID
           // self.navigationController?.pushViewController(rateDriverVC, animated: true)
            self.buttonMoov.isUserInteractionEnabled = true
            self.mapView.clear()
            
        }
    }*/
    
    //MARK:- Action Start Ride
    func actionStartRide(driverID : Int){
        self.geoFire    = GeoFire(firebaseRef: geofireRef)
        let span        = MKCoordinateSpanMake(0.0275, 0.0275)
        let coodinate   = self.currentLocation?.coordinate
        let region      = MKCoordinateRegion(center: coodinate!, span: span)
        if self.regionQuery != nil{
            self.regionQuery?.region = region
        }
        else{
            self.regionQuery = self.geoFire.query(with: region)
        }
        
        self.setUpListeners(query: regionQuery!,driverID : driverID)
    }
    

    //MARK:- SetUp Listeners
    func setUpListeners(query: GFQuery,driverID: Int){
        firebaseHandle = self.geofireRef.child("Users").observe(.value) { [weak self](snap) in
            var dictDriver = NSMutableDictionary()
            
            for rest in snap.children.allObjects as! [DataSnapshot] {
                let dict = (rest.value as! NSDictionary)
                if driverID == Int(dict.value(forKey: "id") as! String) {
                    dictDriver = NSMutableDictionary(dictionary: dict)
                }
            }
            if self?.vehicleMarker != nil {
                
                self?.vehicleMarker.map = self?.mapView
                self?.vehicleMarker.map  = nil
            }
            let usercoordinate = CLLocation(latitude: (self?.currentLocation?.coordinate.latitude)!, longitude: (self?.currentLocation?.coordinate.longitude)!)
            
            self?.ridercoordinate = CLLocation(latitude: CLLocationDegrees(dictDriver.value(forKey: "lat") as! String)!, longitude: CLLocationDegrees(dictDriver.value(forKey: "longt") as! String)!)
            
            if self?.vehicleMarker == nil{
                self?.vehicleMarker = VehicleMarker()
                self?.vehicleMarker.position  = (self?.ridercoordinate.coordinate)!
                
                DispatchQueue.main.async {
                    self?.vehicleMarker?.icon = #imageLiteral(resourceName: "car")
                }
                self?.vehicleMarker.map = self?.mapView
            }
            self?.setPositionOfRider(rider: dictDriver, annotation: (self?.vehicleMarker!)!)
        }
        
    }
        //MARK:- Set Position of rider
        func setPositionOfRider(rider:NSDictionary,annotation:VehicleMarker)
        {
            let prev = rider.value(forKey: "prvLocation") as! NSDictionary
            let prevLat = CLLocationSpeed(prev.value(forKey: "lat") as! String)
            let prevLong = CLLocationSpeed(prev.value(forKey: "longi") as! String)
            
            let oldCord = CLLocationCoordinate2D(latitude: prevLat!, longitude: prevLong!)
           
            
            let newCord = CLLocationCoordinate2D(latitude: CLLocationDegrees(rider.value(forKey: "lat") as! String)!, longitude: CLLocationDegrees(rider.value(forKey: "longt") as! String)!)
            
            if (self.oldAngle == nil) {
                self.oldAngle = rider.value(forKey: "angleX") as? Double
            }
          
                DispatchQueue.main.async {
                    annotation.icon = #imageLiteral(resourceName: "car")
                    self.getPolylineRoute()
                }
            annotation.map = self.mapView
            
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(2.0)
            
            annotation.position = newCord
            UIView.commitAnimations()
            
            annotation.tracksViewChanges = true
            annotation.map = self.mapView
            
            CATransaction.begin()
            CATransaction.setAnimationDuration(3.0)
            annotation.rotation = (self.DegreeBearing(A: CLLocation(latitude: oldCord.latitude, longitude: oldCord.longitude), B: CLLocation(latitude: newCord.latitude, longitude: newCord.longitude)))
            CATransaction.commit()
            
            if (self.oldAngle)! != rider.value(forKey: "angleX") as? Double{
                self.oldAngle = rider.value(forKey: "angleX") as? Double
            }
        }
    
        //MARK:- find angle
        func DegreeBearing(A:CLLocation,B:CLLocation)-> Double {
            var dlon = self.ToRad(degrees: B.coordinate.longitude - A.coordinate.longitude)
            let dPhi = log(tan(self.ToRad(degrees: B.coordinate.latitude) / 2 + .pi / 4) / tan(self.ToRad(degrees: A.coordinate.latitude) / 2 + .pi / 4))
            if  abs(dlon) > .pi {
                dlon = (dlon > 0) ? (dlon - 2 * .pi) : (2 * .pi + dlon)
            }
            return self.ToBearing(radians: atan2(dlon, dPhi))
        }
        
        func ToRad(degrees:Double) -> Double{
            return degrees*(.pi/180)
        }
        
        func ToBearing(radians:Double)-> Double{
            return (ToDegrees(radians: radians) + 360).truncatingRemainder(dividingBy: 360)
        }
        
        func ToDegrees(radians:Double)->Double{
            return radians * 180 / .pi
        }

    
    //MARK:- draw polyline on map
    func getPolylineRoute(){
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(fromCoordinate.latitude),\(fromCoordinate.longitude)&destination=\(ridercoordinate.coordinate.latitude),\(ridercoordinate.coordinate.longitude)&sensor=true&mode=driving&key=AIzaSyBkk3jVs2BDwZzOGQ1Lax5lcVeLPj158Qg")!
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
                // SVProgressHUD.dismiss()
            }
            else {
                do {
                    if let json : [String:Any] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]{
                        
                        guard let routes = json["routes"] as? NSArray else {
                            DispatchQueue.main.async {
                            }
                            return
                        }
                        
                        if (routes.count > 0) {
                            let overview_polyline = routes[0] as? NSDictionary
                            let dictPolyline = overview_polyline?["overview_polyline"] as? NSDictionary
                            
                            let points = dictPolyline?.object(forKey: "points") as? String
                            DispatchQueue.main.async {
                                //    SVProgressHUD.dismiss()
                                let endarray = (overview_polyline?.value(forKeyPath: "legs") as! NSArray)[0]
                                let endlocaton = (endarray as! NSDictionary).value(forKey: "end_location") as! NSDictionary
                                
                                self.showPath(polyStr: points!, lctn: endlocaton)
                               // let bounds = GMSCoordinateBounds(coordinate: source, coordinate: destination)
                               // let update = GMSCameraUpdate.fit(bounds, with: UIEdgeInsetsMake(170, 30, 30, 30))
                                //  self.mapView!.moveCamera(update)
                            }
                        }
                        else {
                            DispatchQueue.main.async {
                                //   self.activityIndicator.stopAnimating()
                            }
                        }
                    }
                }
                catch {
                    print("error in JSONSerialization")
                    DispatchQueue.main.async {
                        //  self.activityIndicator.stopAnimating()
                    }
                }
            }
        })
        task.resume()
    }
    
    func showPath(polyStr :String,lctn : NSDictionary){
        
        let path = GMSPath(fromEncodedPath: polyStr)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 2.0
        polyline.strokeColor = UIColor.green
        polyline.map = mapView
        
        finishmarker = GMSMarker()
        let endLocation = CLLocation(latitude: lctn.value(forKey: "lat") as! CLLocationDegrees, longitude: lctn.value(forKey: "lng") as! CLLocationDegrees)
        finishmarker.position = endLocation.coordinate
        finishmarker.icon = GMSMarker.markerImage(with: UIColor.black)
        finishmarker.map = self.mapView
        
    }
    
    //MARK:- Distance from two locations API
    func calculateDistance()
    {
        let urlAsString = "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=\(userCurentLoaction.latitude),\(userCurentLoaction.longitude)&destinations=\(ridercoordinate.coordinate.latitude),\(ridercoordinate.coordinate.longitude)&key=AIzaSyB6aH2GUchtBI9Pfu6BA8eRTNvvEFCx5r0"
        
        let url = NSURL(string: urlAsString)!
        let request = URLRequest(url: url as URL)
        let urlSession = URLSession.shared
        let dataTask = urlSession.dataTask(with: request, completionHandler: { (data, response, error) in
            if error == nil
            {
                do
                {
                    if let json : [String:Any] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
                    {
                        self.arrayDistance = json["rows"] as! NSArray
                        let distanceDict = self.arrayDistance[0] as! NSDictionary
                        let arrayDistanceElements = distanceDict["elements"] as! NSArray
                        let elementsDict = arrayDistanceElements[0] as! NSDictionary
                        let disatnceDurationDict = elementsDict["duration"] as! NSDictionary
                        let arrivalTime = disatnceDurationDict["text"] as! String
                        let strrArray = arrivalTime.components(separatedBy: CharacterSet.decimalDigits.inverted)
                        
                        for item in strrArray {
                            if let number = Int(item) {
                                print(number)
                                self.expectedTime = number
                            }
                        }
                        if self.expectedTime < 5 {
                            let alert = UIAlertController(title: "Message", message: "Your ride is 5 minutes away, you will be charged a cancellation fee", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction((UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in
                                DispatchQueue.main.async {
                                  self.cancelRide(cancelType: "paid")
                                }
                            })))
                            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }else{
                            let alert = UIAlertController(title: "Message", message: "Do you want to cancell the ride", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction((UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in
                                DispatchQueue.main.async {
                                    self.cancelRide(cancelType: "free")
                                }
                            })))
                            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            
                            
                        }
                    }
                }
                catch
                {
                    print("Error")
                }
            }
        })
        dataTask.resume()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

