//
//  EnterDestinationViewController.swift
//  Moov_Rider
//
//  Created by Visakh on 17/07/18.
//  Copyright © 2018 Visakh. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import Firebase


class EnterDestinationViewController: UIViewController, UITextFieldDelegate, GooglePlacesDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var ImageViewBackround                       : UIImageView!
    @IBOutlet weak var buttonNext                               : UIButton!
    @IBOutlet weak var textFieldEnterDestination                : UITextField!
    @IBOutlet weak var textFieldEnterYourLocation               : UITextField!
    var selectPool                                              = String()
    var numberOfSeats                                           = String()
    var arrayPlaces                                             = NSMutableArray()
    var arrayPlacesName                                         = NSMutableArray()
    var dropdown                                                : BMGooglePlaces!
    var activeTextField                                         : UITextField!
    var userInstituteId                                         : Int!
    
    var currentLocation                                         = CLLocation()
    var placesClient                                            : GMSPlacesClient!
    var zoomLevel                                               : Float = 18.0
    var camera                                                  : GMSCameraPosition!
    var likelyPlaces                                            : [GMSPlace] = []
    
    var selectedPlace                                           : GMSPlace?
    var locationManager                                         = CLLocationManager()
    var userCurentLoaction                                      = CLLocationCoordinate2D()
    var marker                                                  = GMSMarker()
    var markerStart                                             = GMSMarker()
    var markerEnd                                             = GMSMarker()


    @IBOutlet weak var mapView                                  : GMSMapView!
    @IBOutlet weak var viewDriverDetails                        : UIView!
    @IBOutlet weak var cmStar: CosmosView!
    @IBOutlet weak var imageViewDriverProfile                   : UIImageView!
    @IBOutlet weak var labelDriverName                          : UILabel!
    @IBOutlet weak var labelCarName                             : UILabel!
    @IBOutlet weak var labelNoOfTrips                           : UILabel!
    @IBOutlet weak var labelPhoneNumber                         : UILabel!
    @IBOutlet weak var labelDistance                            : UILabel!
    @IBOutlet weak var labelPlateNumber                         : UILabel!
    @IBOutlet weak var labelETA                                 : UILabel!
    @IBOutlet weak var buttonCanecelRide                        : UIButton!
    
    
    var arrayCurrentRideDetails                                 = NSArray()
    var rating                                                  : Int!
    var ratingView                                              = CosmosView()
    var driverID                                                : Int!
    var tripID                                                  : Int!
    var polyLine                                                = GMSPolyline()
    var expectedTime                                            = Int()
    var arrayDistance                                           = NSArray()
    var fromCoordinate                                          : CLLocationCoordinate2D!
    var destinationCoordinate                                          : CLLocationCoordinate2D!
    
    var firebaseHandle                                          : DatabaseHandle!
    var geoFire                                                 : GeoFire!
    let geofireRef                                              = Database.database().reference()
    var regionQuery                                             : GFRegionQuery?
    var vehicleMarker                                           : VehicleMarker!
    
    var oldAngle                                                : Double?
    var ridercoordinate                                         : CLLocation!
    var finishmarker                                            : GMSMarker!
    var polyline : GMSPolyline?
    
    var destCoordinate                                          : CLLocationCoordinate2D!
    override func viewDidLoad() {
        super.viewDidLoad()
        selectPool = "yes"
       self.setupUI()
       // self.ImageViewBackround.isHidden = false
        buttonNext.isHidden = false
       self.userCurrentCollege()
        
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
        
        placesClient = GMSPlacesClient.shared()
        self.viewDriverDetails.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationSend(userInfo:)), name: NSNotification.Name(rawValue: "didReceiveRemoteNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationStopRide), name: NSNotification.Name(rawValue: "didReceiveRemoteNotificationforstopride"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationFutureBook), name: NSNotification.Name(rawValue: "didReceiveRemoteNotificationforFutureRide"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textFieldEnterDestination.text = ""
        textFieldEnterYourLocation.text = ""
        self.userCurrentRides()
        self.buttonNext.isUserInteractionEnabled = true

    }
    func setupUI()  {
        
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
        let btnMenu = UIButton(type: .custom)
        btnMenu.setImage(UIImage(named: "Left_Menu_Icon_3x"), for: .normal)
        btnMenu.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        btnMenu.addTarget(self, action: #selector(sideMenuAction), for: .touchUpInside)
        let item3 = UIBarButtonItem(customView: btnMenu)
        self.navigationItem.setLeftBarButton(item3, animated: true)
        
        /*let logo = UIImage(named: "Let’s moov!")
        let imageViewLogo = UIImageView(image:logo)
        self.navigationItem.titleView = imageViewLogo*/
        self.navigationItem.title = "Moov"
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.red]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        self.textFieldEnterDestination.layer.cornerRadius = 8.0
        self.textFieldEnterDestination.layer.masksToBounds = true
        self.textFieldEnterYourLocation.layer.cornerRadius = 8.0
        self.textFieldEnterYourLocation.layer.masksToBounds = true
        self.textFieldEnterDestination.layer.borderWidth = 1.0
        self.textFieldEnterDestination.layer.borderColor = UIColor.lightGray.cgColor
        self.textFieldEnterYourLocation.layer.borderWidth = 1.0
        self.textFieldEnterYourLocation.layer.borderColor = UIColor.lightGray.cgColor
        
        textFieldEnterDestination.leftViewMode = .always
        let imageView = UIImageView(frame:CGRect(x: 0, y: 0, width: 30, height: 30))
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
        let imageView1 = UIImageView(frame:CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView1.image = #imageLiteral(resourceName: "map yellow pointer")
        let paddingView1 = UIView(frame:CGRect(x: 0, y: 0, width: 40, height: textFieldEnterYourLocation.frame.height))
        let paddingViewW = UIView(frame:CGRect(x: 0, y: 0, width: 40, height: textFieldEnterYourLocation.frame.height))
        imageView1.center = paddingView1.center
        paddingView1.addSubview(imageView1)
        imageView1.contentMode = .scaleAspectFit
        paddingViewW.addSubview(paddingView1)
        paddingViewW.backgroundColor = UIColor.clear
        textFieldEnterYourLocation.leftView = paddingViewW
        
        self.buttonNext.layer.cornerRadius = 10.0
        self.buttonNext.layer.masksToBounds = true
        
        
        
        
        viewDriverDetails.layer.cornerRadius = 10.0
        viewDriverDetails.layer.borderColor = UIColor.lightGray.cgColor
        viewDriverDetails.layer.borderWidth = 0.5
        viewDriverDetails.layer.masksToBounds = true
        imageViewDriverProfile.layer.cornerRadius = 10.0
        imageViewDriverProfile.layer.masksToBounds = true
        buttonCanecelRide.layer.cornerRadius = 5.0
        buttonCanecelRide.layer.masksToBounds = true
        
        
    }
    @objc func notificationAction() {
        let walletVc = self.storyboard?.instantiateViewController(withIdentifier: "MyWalletViewController") as! MyWalletViewController
        self.navigationController?.pushViewController(walletVc, animated: true)
    }
    //MARK:- Toggle SideMenu
    @objc func sideMenuAction() {
        menuContainerViewController.toggleLeftSideMenuCompletion(nil)
    }
    @IBAction func buttonNextAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if textFieldEnterDestination.text?.isEmpty == false{
            if textFieldEnterYourLocation.text?.isEmpty == false{
                if textFieldEnterDestination.text == textFieldEnterYourLocation.text {
                    GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Choose another location")
                }else{
                self.chooseDestination()
                }
            }else{
                GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Please fill all the fields")
            }
        }else{
            GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Please fill all the fields")
        }
        
    }
    @IBAction func buttonDoYouWantToPoolAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true{
            selectPool = "no"
        }else{
            selectPool = "yes"
        }
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func selectedPlace(_ place: NSObject!) {
        let selecetedPlace = place as! SPGooglePlacesAutocompletePlace
        if self.activeTextField.tag == 20
        {
            self.textFieldEnterDestination.text = selecetedPlace.name
            self.destinationCoordinate = self.getLocationFromAddressString(selecetedPlace.placeId)

            textFieldEnterDestination.resignFirstResponder()
        }
        else if activeTextField.tag == 30
        {
            self.textFieldEnterYourLocation.text = selecetedPlace.name
            self.fromCoordinate = self.getLocationFromAddressString(selecetedPlace.placeId)

            textFieldEnterYourLocation.resignFirstResponder()
        }
        self.dropdown = nil
    }
    
    //MARK:- Api
    func chooseDestination()
    {
        let src = textFieldEnterYourLocation.text?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let dest = textFieldEnterDestination.text?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
       numberOfSeats = "1"
        let hud = GenericFunctions.showJHud(target: self)
        AlamofireSubclass.parseLinkUsingGetMethod("ride/search/amount/\(src!)/\(dest!)/\(numberOfSeats)/\(selectPool)") { (success, response, error) in
            hud.hide()
            if success == true {
                if response!["message"] as! String == "Amount calculated" {
                   
                    let selectSeatVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectSeatsViewController") as! SelectSeatsViewController
                    selectSeatVC.Destination = self.textFieldEnterDestination.text!
                    selectSeatVC.Location = self.textFieldEnterYourLocation.text!
                    let data = response!["data"] as! NSDictionary
                    selectSeatVC.amount = data["amount"] as! Double
                    selectSeatVC.selectPool = self.selectPool
                    selectSeatVC.collegeID = self.userInstituteId
                    selectSeatVC.fromCoordinate = self.fromCoordinate
                    selectSeatVC.destCoordinate = self.destinationCoordinate
                    self.navigationController?.pushViewController(selectSeatVC, animated: true)
                    
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
                self.userInstituteId = (response!["data"] as! NSDictionary)["user_institute"] as! Int
                // self.listColleges()
                //self.currentCollegeName = (self.arrayCollegeNameList[userInstituteId] as! String)
            }else{
                GenericFunctions.showAlertView(targetVC: self, title: "Error", message: (error?.localizedDescription)!)
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
        
        let locationArray = locations as NSArray
        let locationObj = locationArray.lastObject as! CLLocation
        let coord = locationObj.coordinate
        userCurentLoaction = locationObj.coordinate
        currentLocation = locations.last!
       // getAddressFromLatLon(pdblLatitude: (currentLocation.coordinate.latitude), withLongitude: (currentLocation.coordinate.longitude))
       getAddressFromLatLon(pdblLatitude: userCurentLoaction.latitude, withLongitude: userCurentLoaction.longitude)
        mapView.isMyLocationEnabled = true
        let point = mapView.projection.point(for: (self.currentLocation.coordinate))
        
        let camera : GMSCameraUpdate!
        camera = GMSCameraUpdate.setTarget(mapView.projection.coordinate(for: point), zoom: 12.0)
        mapView.animate(with: camera)
        
    }
    //MARK:- Get User Current Ride
    
    func userCurrentRides(){
        let hud = GenericFunctions.showJHud(target: self)
        AlamofireSubclass.parseLinkUsingGetMethod("view/rides/current/user/\(User.current.user_details!.u_id!)") { (success, response, error) in
            hud.hide()
            if success == true{
                if response!["message"] as! String == "Rides Lists" {
                    let data = response!["data"] as! NSArray
                    var dict = NSDictionary()
                    for liveRide in data {
                        
                        let status = (liveRide as! NSDictionary)["ride_type"] as! String
                        if status == "live"{
                            dict = liveRide as! NSDictionary
                        }else{
                            
                        }
                    }
                    if dict.count > 0 {
                        let driverDetails = dict["driver_details"] as! NSDictionary
                        if dict["ride_type"] as? String == "live" {
                            self.labelDriverName.text = driverDetails["first_name"] as? String
                            self.labelCarName.text = driverDetails["car_model"] as? String
                            self.labelPhoneNumber.text = driverDetails["phone"] as? String
                            self.labelDistance.text = dict["distance"] as? String
                            self.labelPlateNumber.text = driverDetails["vehicle_no"] as? String
                            self.labelETA.text = dict["time"] as? String
                            let imageUrl = driverDetails["image"] as? String
                            //self.labelNoOfTrips.text = String(driverDetails["total_rides"] as! Int)
                            self.imageViewDriverProfile.sd_setImage(with: URL(string: imageUrl!), placeholderImage: #imageLiteral(resourceName: "dummy") , options: .highPriority) { (image, error, cache, url) in
                                //
                            }
                            let rating = driverDetails["ratings"] as? Double
                            self.cmStar.rating = rating!
                            print(self.rating)
                            self.viewDriverDetails.isHidden = false
                            self.tripID = dict["ride_id"] as! Int
                            let polyline = dict["poly_line"] as! String
                            let path = GMSPath.init(fromEncodedPath: polyline)
                            self.polyLine = GMSPolyline(path: path)
                            self.polyLine.strokeColor = .blue
                            self.polyLine.strokeWidth = 3.0
                            self.polyLine.map = self.mapView
                            
                            let coordinates = dict["poly_lines"] as! NSDictionary
                            let startCoordinates = coordinates["start"] as! NSDictionary
                            let EndCoordinates = coordinates["end"] as! NSDictionary
                            
                            let startLat = startCoordinates["lat"] as! Double
                            let startLong = startCoordinates["lng"] as! Double
                            let EndLat = EndCoordinates["lat"] as! Double
                            let EndLong = EndCoordinates["lng"] as! Double
                            
                            let position = CLLocationCoordinate2DMake(startLat,startLong)
                            self.markerStart = GMSMarker(position: position)
                            self.markerStart.map = self.mapView
                                    
                            let positionEnd = CLLocationCoordinate2DMake(EndLat,EndLong)
                            self.markerEnd = GMSMarker(position: positionEnd)
                            self.markerEnd.icon = GMSMarker.markerImage(with: UIColor.green)
                            self.markerEnd.map = self.mapView
                            
                            self.driverID = driverDetails["driver_id"] as! Int
                            
                             self.actionStartRide(driverID : self.driverID)
                            self.buttonNext.isUserInteractionEnabled = false
                            
                        }else{
                            self.viewDriverDetails.isHidden = true
                            self.polyLine.map = nil
                            self.markerEnd.map = nil
                            self.markerStart.map = nil
                        }
                    }else{
                        self.viewDriverDetails.isHidden = true
                        self.polyLine.map = nil
                        self.markerEnd.map = nil
                        self.markerStart.map = nil
                    }
                    
                }else{
                     self.viewDriverDetails.isHidden = true
                    self.polyLine.map = nil
                    self.markerEnd.map = nil
                    self.markerStart.map = nil
                }
            }else{
                GenericFunctions.showAlertView(targetVC: self, title: "Messgae", message: (error?.localizedDescription)!)
            }
        }
    }
    @IBAction func buttonCancelRideAction(_ sender: UIButton) {
        //self.cancelRide(tripId: String(tripID!))
        
        self.calculateDistance()
    }
    //MARK:- API Cancel Ride
    func cancelRide(tripId:String!, cancelType : String!)  {
        let hud = GenericFunctions.showJHud(target: self)
        AlamofireSubclass.parseLinkUsingGetMethod("rides/cancel/\(tripId!)/\(cancelType!)") { (success, response, error) in
            hud.hide()
            if success == true{
                if response!["message"] as! String == "Ride cancelled"{
                    self.mapView.clear()
                    self.buttonNext.isUserInteractionEnabled = true
                    let alert = UIAlertController(title: "Message", message: "Successfully cancel your ride", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction((UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in
                        self.userCurrentRides()
                    })))
                    self.present(alert, animated: true, completion: nil)
                     self.viewDriverDetails.isHidden = true
                    self.mapView.clear()
                }else{
                    GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "An error occured")
                }
                
            }else{
                GenericFunctions.showAlertView(targetVC: self, title: "Message", message: (error?.localizedDescription)!)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func keyboardHide(){
        //textFieldEnterDestination.resignFirstResponder()
        //textFieldEnterYourLocation.resignFirstResponder()
    }
    
    //MARK:- Action Start Ride
    func actionStartRide(driverID : Int){
        self.geoFire    = GeoFire(firebaseRef: geofireRef)
        let span        = MKCoordinateSpanMake(0.0275, 0.0275)
        let coodinate   = self.currentLocation.coordinate
        let region      = MKCoordinateRegion(center: coodinate, span: span)
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
           // let usercoordinate = CLLocation(latitude: (self?.currentLocation.coordinate.latitude)!, longitude: (self?.currentLocation.coordinate.longitude)!)
            
            self?.ridercoordinate = CLLocation(latitude: CLLocationDegrees(dictDriver.value(forKey: "lat") as! String)!, longitude: CLLocationDegrees(dictDriver.value(forKey: "longt") as! String)!)
            self?.getPolylineRoute()
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
            //self.getPolylineRoute()
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
        let fromCoordinates : NSDictionary!
        if (UserDefaults.standard.object(forKey: "fromCoordinates") != nil){
            fromCoordinates = NSKeyedUnarchiver.unarchiveObject(with: (UserDefaults.standard.object(forKey: "fromCoordinates") as! NSData) as Data) as! NSDictionary
            
           // var userLoc = UserDefaults.standard.object(forKey: "fromCoordinates") as? [AnyHashable : Any]
         
            let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(String(describing: fromCoordinates!["lat"]!)),\(String(describing: fromCoordinates!["long"]!))&destination=\(ridercoordinate.coordinate.latitude),\(ridercoordinate.coordinate.longitude)&sensor=true&mode=driving&key=AIzaSyBkk3jVs2BDwZzOGQ1Lax5lcVeLPj158Qg")!
        
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
    }
    
    
    func showPath(polyStr :String,lctn : NSDictionary){
        
        if polyline != nil{
            polyline?.map = nil
        }
        let path = GMSPath(fromEncodedPath: polyStr)
         polyline = GMSPolyline(path: path)
       
        polyline?.strokeWidth = 2.0
        polyline?.strokeColor = UIColor.green
        polyline?.map = mapView
        
        //finishmarker = GMSMarker()
        let endLocation = CLLocation(latitude: lctn.value(forKey: "lat") as! CLLocationDegrees, longitude: lctn.value(forKey: "lng") as! CLLocationDegrees)
       // finishmarker.position = endLocation.coordinate
        
        //finishmarker.icon = GMSMarker.markerImage(with: UIColor.black)
       // finishmarker.map = self.mapView
        
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
                                    self.cancelRide(tripId: String(self.tripID!), cancelType: "paid")
                                }
                            })))
                            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }else{
                            let alert = UIAlertController(title: "Message", message: "Do you want to cancell the ride", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction((UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in
                                DispatchQueue.main.async {
                                    self.cancelRide(tripId: String(self.tripID!), cancelType: "free")
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
    
    func getLocationFromAddressString(_ placeId: String) -> CLLocationCoordinate2D {
        var latitude: Double = 0
        var longitude: Double = 0
        var center = CLLocationCoordinate2D()
        let esc_addr: String? = placeId.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let req = "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(String(describing: esc_addr!))&key=AIzaSyDpEOdHfWlmp5nmCak91Xxfdw6rvUQXn50"
        //SVProgressHUD.show()
        let result = try? String(contentsOf: URL(string: req)!, encoding: .utf8)
        if result != nil {
            //  SVProgressHUD.dismiss()
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
    
    //MARK:- Get address String from Location
    func getAddressFromLatLon(pdblLatitude: Double, withLongitude pdblLongitude: Double) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = pdblLatitude
        
        let lon: Double = pdblLongitude
        
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        fromCoordinate = center
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                guard let pm = placemarks else { return }
                
                if pm.count > 0 {
                    let pm = placemarks![0]
//                    print(pm.country!)
//                    print(pm.locality!)
//                    print(pm.subLocality!)
                    //print(pm.thoroughfare!)
//                    print(pm.postalCode!)
                    //print(pm.subThoroughfare!)
                    var addressString : String = ""
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country!
                    }
                    /*if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }*/
                    
                    self.textFieldEnterYourLocation.text = addressString
                    print(addressString)
                }
        })
        
    }

    
    
    //MARK :- Notification Start Ride
    @objc func notificationSend(userInfo : NSNotification){
        if viewDriverDetails.isHidden == false{
            UserDefaults.standard.set(true, forKey: "status")
            self.buttonCanecelRide.isHidden = true
        }
    }
    //MARK :- Notification Stop ride
    @objc func notificationStopRide(){
        if viewDriverDetails.isHidden == false{
            self.viewDriverDetails.isHidden = true
            let rateDriverVC = self.storyboard?.instantiateViewController(withIdentifier: "RateDriverViewController") as! RateDriverViewController
            rateDriverVC.driverId = driverID
            rateDriverVC.tripID = tripID
            self.navigationController?.pushViewController(rateDriverVC, animated: true)
           //self.buttonMoov.isUserInteractionEnabled = true
            self.mapView.clear()
            
        }
    }
    
    //MARK:- Notification Future Booking
    @objc func notificationFutureBook(){
       self.userCurrentRides()
    }
    
    
}
