//
//  FutureBookingViewController.swift
//  Moov_Rider
//
//  Created by Visakh on 03/09/18.
//  Copyright © 2018 Visakh. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import CoreLocation

class FutureBookingViewController: UIViewController,  NIDropDownDelegate, CLLocationManagerDelegate,UITextFieldDelegate, GooglePlacesDelegate {

    @IBOutlet weak var viewWarning: UIView!
    @IBOutlet weak var textFieldNoofSeats           : UITextField!
    @IBOutlet weak var textFileUniversity           : UITextField!
    @IBOutlet weak var textFieldEnterDestination    : UITextField!
    @IBOutlet weak var textFieldEnterYourLocation   : UITextField!
    @IBOutlet weak var labelAmount                  : UILabel!
    @IBOutlet weak var texfieldDate                 : UITextField!
    @IBOutlet weak var textFieldTime                : UITextField!
    @IBOutlet weak var buttonSelectSeats            : UIButton!
    @IBOutlet weak var buttonBook                   : UIButton!
    @IBOutlet weak var buttonAlert                  : UIButton!
    
    
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
    
    var currentLocation                             : CLLocation?
    var placesClient                                : GMSPlacesClient!
    var zoomLevel                                   : Float = 50.0
    var camera                                      : GMSCameraPosition!
    var likelyPlaces                                : [GMSPlace] = []
    
    var selectedPlace                               : GMSPlace?
    let datePicker                                  = UIDatePicker()
    let timePicker                                  = UIDatePicker()
    
    var fromCoordinate : CLLocationCoordinate2D!
    var destCoordinate : CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.userCurrentCollege()
        dropdownArr = ["1","2","3","4","5","6","7"]
        nidropDown.delegate = self
        self.listColleges()
        self.showWalletBalance()
        self.labelAmount.text = String(amount)
        self.buttonAlert.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
         self.showWalletBalance()
        textFieldEnterDestination.text = Destination
        textFieldEnterYourLocation.text = Location
        self.showDatePicker()
        self.showTimePicker()
        var components = DateComponents()
        components.year = 0
        let minDate = Calendar.current.date(byAdding: components, to: Date())
        datePicker.minimumDate = minDate
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
        
        self.texfieldDate.layer.borderWidth = 1.0
        self.texfieldDate.layer.borderColor = UIColor.lightGray.cgColor
        self.texfieldDate.layer.cornerRadius = 8.0
        self.texfieldDate.layer.masksToBounds = true
        
        self.textFieldTime.layer.borderWidth = 1.0
        self.textFieldTime.layer.borderColor = UIColor.lightGray.cgColor
        self.textFieldTime.layer.cornerRadius = 8.0
        self.textFieldTime.layer.masksToBounds = true
        
        
        self.buttonSelectSeats.layer.borderWidth = 1.0
        self.buttonSelectSeats.layer.borderColor = UIColor.lightGray.cgColor
        self.buttonSelectSeats.layer.cornerRadius = 8.0
        self.buttonSelectSeats.layer.masksToBounds = true
        
        self.buttonBook.layer.borderWidth = 1.0
        self.buttonBook.layer.borderColor = UIColor.lightGray.cgColor
        self.buttonBook.layer.cornerRadius = 8.0
        self.buttonBook.layer.masksToBounds = true
        
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
        
        let btnMenu = UIButton(type: .custom)
        btnMenu.setImage(#imageLiteral(resourceName: "Back_Button_3x"), for: .normal)
        btnMenu.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        btnMenu.addTarget(self, action: #selector(sideMenuAction), for: .touchUpInside)
        let item3 = UIBarButtonItem(customView: btnMenu)
        self.navigationItem.setLeftBarButton(item3, animated: true)
        
        let btn1 = UIButton(type: .custom)
        btn1.setBackgroundImage(#imageLiteral(resourceName: "wallet"), for: .normal)
        btn1.imageView?.contentMode = .scaleAspectFit
        //btn1.setImage(UIImage(named: "Notification_button_3x"), for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        btn1.addTarget(self, action: #selector(buttonWalletAction), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: btn1)
        
        let btn2 = UIButton(type: .custom)
        
        // btn2.setImage(UIImage(named: "Notification_button_3x"), for: .normal)
        btn2.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        btn2.addTarget(self, action: #selector(buttonWalletAction), for: .touchUpInside)
        let item2 = UIBarButtonItem(customView: btn2)
        
        self.navigationItem.setRightBarButtonItems([item1,item2], animated: true)
        
        
        self.navigationItem.title = "Future Booking"
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.red]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        
        
        
        
        
    }
    //MARK:- Toggle SideMenu
    @objc func sideMenuAction() {
        self.dismiss(animated: true, completion: nil)
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
                    self.buttonBook.setTitle("Recharge", for: .normal)
                }else{
                    self.buttonAlert.isHidden = true
                    self.buttonBook.setTitle("BOOK", for: .normal)
                }
                
            }else{
                GenericFunctions.showAlertView(targetVC: self, title: "Error", message: (error?.localizedDescription)!)
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
    //MARK:- Dropdown delegate
    func niDropDownDelegateMethod(_ sender: UIButton!, selectedIndex index: Int32) {
        
        if selectUniversity == true {
            self.textFieldNoofSeats.text = (dropdownArr[Int(index)] as! String)
            
            chooseDestination()
        }else{
            self.textFileUniversity.text = (arrayCollegeNameList[Int(index)] as! String)
            collegeID = arrayCollegeList[Int(index)].id
        }
        nidropDown.hide(previousDropBtn)
        nidropDown.removeFromSuperview()
        
    }
    
    func geoCode(usingAddress address: String?) -> CLLocationCoordinate2D {
        var latitude: Double = 0
        var longitude: Double = 0
        let esc_addr = address?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)
        //addingPercentEscapes(using: String.Encoding.utf8.rawValue)
        let req = "http://maps.google.com/maps/api/geocode/json?sensor=false&address=\(esc_addr ?? "")"
        var result: String? = nil
        if let aReq = URL(string: req) {
            result = try? String(contentsOf: aReq, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
        }
        if result != nil {
            let scanner = Scanner(string: result ?? "")
            if scanner.scanUpTo("\"lat\" :", into: nil) && scanner.scanString("\"lat\" :", into: nil) {
                scanner.scanDouble(&latitude)
                if scanner.scanUpTo("\"lng\" :", into: nil) && scanner.scanString("\"lng\" :", into: nil) {
                    scanner.scanDouble(&longitude)
                }
            }
        }
        var center = CLLocationCoordinate2D()
        center.latitude = CLLocationDegrees(latitude)
        center.longitude = CLLocationDegrees(longitude)
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
    
    func  locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        var locationArray = locations as! NSArray
        var locationObj = locationArray.lastObject as! CLLocation
        var coord = locationObj.coordinate
        userCurentLoaction = locationObj.coordinate
        currentLocation = locations.last!
        
    }
    
    //MARK:- Textfield Delegates
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
    //MARK:- Wallet Action
    @objc func buttonWalletAction() {
        let walletVc = self.storyboard?.instantiateViewController(withIdentifier: "MyWalletViewController") as! MyWalletViewController
        self.navigationController?.pushViewController(walletVc, animated: true)
        
    }
    func selectedPlace(_ place: NSObject!) {
        let selecetedPlace = place as! SPGooglePlacesAutocompletePlace
        if self.activeTextField.tag == 20
        {
            self.textFieldEnterDestination.text = selecetedPlace.name
            self.destCoordinate = self.getLocationFromAddressString(selecetedPlace.placeId)
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.textFieldEnterDestination.resignFirstResponder()
        self.textFieldEnterYourLocation.resignFirstResponder()
        return true
    }
    
    //MARK:- Api Ride amount
    
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
    
    //MARK Button Actions
    @IBAction func buttonSelectSeatsAction(_ sender: UIButton) {
        sender.isSelected   = !sender.isSelected
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
    
    @IBAction func buttonBookRideAction(_ sender: UIButton) {
        
        let balance = Float(self.walletBalance)
        if balance! < Float(self.amount) {
            let walletVc = self.storyboard?.instantiateViewController(withIdentifier: "MyWalletViewController") as! MyWalletViewController
            walletVc.pageID = "Future Booking"
            self.navigationController?.pushViewController(walletVc, animated: true)
        }else{
            if texfieldDate.text?.isEmpty == false {
                if textFieldTime.text?.isEmpty == false{
                    if textFieldEnterDestination.text == textFieldEnterYourLocation.text{
                        GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Choose another location")
                    }else{
                    self.bookAFutureRide()
                    }
                }else{
                    GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Please select time of booking")
                }
            }else{
                GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Please select date of booking")
            }
        }
    }
    //MARK:- Date Picker
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        texfieldDate.inputAccessoryView = toolbar
        texfieldDate.inputView = datePicker
        
    }
    //MARK:- Time Pikcer
    func showTimePicker(){
        //Formate time
        timePicker.datePickerMode = .time
        timePicker.locale = Locale(identifier: "en_GB")
       
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTimePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        textFieldTime.inputAccessoryView = toolbar
        textFieldTime.inputView = timePicker
        
    }
    @objc func donedatePicker(){
        let formatter = DateFormatter()
        //formatter.dateStyle = .long
        formatter.dateFormat = "yyyy-MM-dd"
        texfieldDate.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    @objc func doneTimePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
       // formatter.timeStyle = .short
        textFieldTime.text = formatter.string(from: timePicker.date)
        self.view.endEditing(true)
    }
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    //MARK:- API Future Booking
    
    func bookAFutureRide()  {
        var params  : NSDictionary?
        let src = textFieldEnterYourLocation.text?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let dest = textFieldEnterDestination.text?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        //let fromCoordinate = self.geoCode(usingAddress: textFieldEnterYourLocation.text!)
        let fromLat = String(fromCoordinate.latitude)
        let fromLong = String(fromCoordinate.longitude)
       // let destCordinate = self.geoCode(usingAddress: textFieldEnterDestination.text!)
        let destLat = String(destCoordinate.latitude)
        let destLong = String(destCoordinate.longitude)
        
        
        params = ["userid": String(User.current.user_details!.u_id!), "from": src!, "from_lat":fromLat, "from_long":fromLong, "to": dest! ,"to_lat":destLat, "to_long":destLong, "pooling":selectPool!, "seats":textFieldNoofSeats.text!, "collegeid": String(collegeID!), "amount": String(amount!), "current_lat":String(userCurentLoaction.latitude), "current_long":String(userCurentLoaction.longitude), "booking_to_date" : self.texfieldDate.text!, "booking_to_time": self.textFieldTime.text!]
        
        let hud = GenericFunctions.showJHud(target: self)
        AlamofireSubclass.parseLinkUsingPostMethod("ride/book_future", with: params!) { (success, response, error) in
            hud.hide()
            if success == true{
                if response!["message"] as! String == "Ride booked"{
                    let alert = UIAlertController(title: "Message", message: "Successfully book your ride", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction((UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in
                        //self.dismiss(animated: true, completion: nil)
                        let homePage = self.storyboard?.instantiateViewController(withIdentifier: "EnterDestinationViewController")
                            as! EnterDestinationViewController
                        let navVC = UINavigationController(rootViewController: homePage)
                        let sideVC = self.storyboard?.instantiateViewController(withIdentifier: "SideMenuTableViewController") as! SideMenuTableViewController
                        let mfContainer = MFSideMenuContainerViewController.container(withCenter: navVC, leftMenuViewController: sideVC, rightMenuViewController: nil)
                        UIApplication.shared.keyWindow?.rootViewController = mfContainer
                        
                        
                        
                    })))
                    self.present(alert, animated: true, completion: nil)
                    
                }else{
                    GenericFunctions.showAlertView(targetVC: self, title: "Message", message: "Please try again")
                }
            }else{
                GenericFunctions.showAlertView(targetVC: self, title: "Message", message: (error?.localizedDescription)!)
            }
        }
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
