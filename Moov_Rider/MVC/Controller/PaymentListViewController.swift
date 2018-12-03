//
//  PaymentListViewController.swift
//  Spourtfy
//
//  Created by Vishnu's Mac on 19/07/18.
//  Copyright © 2018 Vishnu M P. All rights reserved.
//

import UIKit

class PaymentListViewController: UIViewController {

    @IBOutlet weak var tabelViewList        : UITableView!
    var dataArray                           = NSMutableArray()
    var previousRidesDict                   = NSDictionary()
    var pageID                              : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.previousRides()
        self.tabelViewList.dataSource = self
        self.tabelViewList.delegate = self
        self.setupUI()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.previousRides()

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
        btnMenu.setImage(#imageLiteral(resourceName: "Back_Button_3x"), for: .normal)
        btnMenu.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        btnMenu.addTarget(self, action: #selector(sideMenuAction), for: .touchUpInside)
        let item3 = UIBarButtonItem(customView: btnMenu)
        self.navigationItem.setLeftBarButton(item3, animated: true)
        
        if pageID == "PreviousRides"{
            self.navigationItem.title = "Previous Rides"
            let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.red]
            navigationController?.navigationBar.titleTextAttributes = textAttributes
        }else{
            self.navigationItem.title = "Payments"
            let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.red]
            navigationController?.navigationBar.titleTextAttributes = textAttributes
        }
    }
    @objc func notificationAction() {
        
        let walletVc = self.storyboard?.instantiateViewController(withIdentifier: "MyWalletViewController") as! MyWalletViewController
        self.navigationController?.pushViewController(walletVc, animated: true)
        
    }
    //MARK:- Toggle SideMenu
    @objc func sideMenuAction() {
        menuContainerViewController.toggleLeftSideMenuCompletion(nil)
    }
    //MARK:- Api Previous rides
    func previousRides(){
        let userID = String(User.current.user_details!.u_id!)
        let hud = GenericFunctions.showJHud(target: self)
        AlamofireSubclass.parseLinkUsingGetMethod("view/rides/user/\(userID)") { (success, response, error) in
            hud.hide()
            if success == true {
                if response!["message"] as! String == "Rides Lists" {
                    self.dataArray = NSMutableArray(array: response!["data"] as! NSArray)
                    self.tabelViewList.reloadData()
                }
                else {
                    GenericFunctions.showAlertView(targetVC: self, title: "Error", message: "No histories")
                }
                
            }else{
                GenericFunctions.showAlertView(targetVC: self, title: "Error", message: (error?.localizedDescription)!)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func buttonUnPaidOrPaidActions(_ sender: UIButton) {
        
       
        
        let dict = dataArray[sender.tag] as! NSDictionary
          if pageID == "PreviousRides"{
          }else{
        if dict["ride_payment_status"]as! String == "unpaid" {
            let unPaidVC = self.storyboard?.instantiateViewController(withIdentifier: "UnpaidPaymentViewController") as! UnpaidPaymentViewController
            unPaidVC.rideID =  String(dict["ride_id"]as! Int)
            unPaidVC.rideAmount = dict["ride_amount"]as! String
            self.navigationController?.pushViewController(unPaidVC, animated: true)
        }else{
            let rateVC = self.storyboard?.instantiateViewController(withIdentifier: "RateDriverViewController") as! RateDriverViewController
            rateVC.tripID = dict["ride_id"]as! Int
            rateVC.driverId = dict["ride_driver_id"]as! Int
            self.navigationController?.pushViewController(rateVC, animated: true)
        }
        }
    }
}

//MARK:- TableViewDataSource
extension PaymentListViewController : UITableViewDataSource {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PaymentListTableViewCell
        let dict = dataArray[indexPath.row] as! NSDictionary
        
        let source = dict["ride_from"] != nil ? dict["ride_from"] as! String : ""
        source.components(separatedBy: ",").first
        cell.lblSource.text = source.components(separatedBy: ",").first
        let dest = dict["ride_to"] != nil ? dict["ride_to"] as! String : ""
        cell.lblDestination.text = dest.components(separatedBy: ",").first
        cell.lblDate.text = dict["ride_booked_on_date"] != nil ? dict["ride_booked_on_date"] as! String : ""
        cell.lblTime.text = dict["ride_booked_on_time"] != nil ? dict["ride_booked_on_time"] as! String : ""
        cell.lblSeats.text = "\(String(dict["ride_seats"] as! Int)) Seats"
        cell.lblPrice.text = "$\(dict["ride_amount"] != nil ? dict["ride_amount"] as! String : "")"
        
        if pageID == "PreviousRides"{
            cell.buttonPaymentStatus.tag = indexPath.row
           // if  dict["ride_status"] as! String == "booked"{
                cell.buttonPaymentStatus.setTitle(dict["ride_status"] as? String, for: .normal)
                cell.bgView.backgroundColor = UIColor.white
                cell.buttonPaymentStatus.setBackgroundImage(#imageLiteral(resourceName: "gray_bg-1"), for: .normal)
                cell.lblSource.textColor = UIColor.black
                cell.lblDestination.textColor = UIColor.black
                cell.lblDate.textColor = UIColor.black
                cell.lblTime.textColor = UIColor.black
                cell.lblSeats.textColor = UIColor.black
                cell.lblPrice.textColor = UIColor.black
                cell.buttonPaymentStatus.setTitleColor(UIColor.init(red: 255/255.0, green: 25/255.0, blue: 101/255.0, alpha: 1.0), for: .normal)
           /* }
            else{
                cell.buttonPaymentStatus.setTitle("PAID", for: .normal)
                cell.bgView.backgroundColor = UIColor.white
                cell.buttonPaymentStatus.setBackgroundImage(#imageLiteral(resourceName: "gray_bg-1"), for: .normal)
                cell.lblSource.textColor = UIColor.black
                cell.lblDestination.textColor = UIColor.black
                cell.lblDate.textColor = UIColor.black
                cell.lblTime.textColor = UIColor.black
                cell.lblSeats.textColor = UIColor.black
                cell.lblPrice.textColor = UIColor.black
                cell.buttonPaymentStatus.setTitleColor(UIColor.init(red: 255/255.0, green: 25/255.0, blue: 101/255.0, alpha: 1.0), for: .normal)
            }*/
        }else{
            cell.buttonPaymentStatus.tag = indexPath.row
            if  dict["ride_payment_status"] as! String == "unpaid"{
                cell.buttonPaymentStatus.setTitle("UNPAID", for: .normal)
                cell.bgView.backgroundColor = UIColor.red
                cell.buttonPaymentStatus.setBackgroundImage(#imageLiteral(resourceName: "blackBg"), for: .normal)
                cell.lblSource.textColor = UIColor.white
                cell.lblDestination.textColor = UIColor.white
                cell.lblDate.textColor = UIColor.white
                cell.lblTime.textColor = UIColor.white
                cell.lblSeats.textColor = UIColor.white
                cell.lblPrice.textColor = UIColor.white
                cell.buttonPaymentStatus.setTitleColor(UIColor.init(red: 255/255.0, green: 195/255.0, blue: 92/255.0, alpha: 1.0), for: .normal)
            }else{
                cell.buttonPaymentStatus.setTitle("PAID", for: .normal)
                cell.bgView.backgroundColor = UIColor.white
                cell.buttonPaymentStatus.setBackgroundImage(#imageLiteral(resourceName: "gray_bg-1"), for: .normal)
                cell.lblSource.textColor = UIColor.black
                cell.lblDestination.textColor = UIColor.black
                cell.lblDate.textColor = UIColor.black
                cell.lblTime.textColor = UIColor.black
                cell.lblSeats.textColor = UIColor.black
                cell.lblPrice.textColor = UIColor.black
                cell.buttonPaymentStatus.setTitleColor(UIColor.init(red: 255/255.0, green: 25/255.0, blue: 101/255.0, alpha: 1.0), for: .normal)
            }
        }
        
      
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
}
//MARK:- TableViewDelegate
extension PaymentListViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = dataArray[indexPath.row] as! NSDictionary
        if pageID == "PreviousRides"{
            let rateDriverVC = self.storyboard?.instantiateViewController(withIdentifier: "RateDriverViewController") as! RateDriverViewController
            rateDriverVC.driverId = dict["ride_driver_id"] as! Int
            rateDriverVC.tripID = dict["ride_trip_id"] as! Int
            self.navigationController?.pushViewController(rateDriverVC, animated: true)
        }else{
            
        }
        
       
    }
    
}

