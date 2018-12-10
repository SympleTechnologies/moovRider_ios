//
//  College.swift
//  Moov_Rider
//
//  Created by Visakh on 19/07/18.
//  Copyright © 2018 Visakh. All rights reserved.
//

import UIKit

class College: NSObject {

    var name : String!
    var id : Int!
    
    func initWith(_ dictionary : NSDictionary)-> College {
        name = dictionary["name"] != nil ? dictionary["name"] as! String  : ""
        id = dictionary["id"] != nil ? dictionary["id"] as! Int  : 0
        
        return self
    }
    
}

class UserType: NSObject {
    
    var role : String!
    var id : Int!
    
    func initWith(_ dictionary : NSDictionary)-> UserType {
        role = dictionary["name"] != nil ? dictionary["name"] as! String  : ""
        id = dictionary["id"] != nil ? dictionary["id"] as! Int  : 0
        
        return self
    }
    
}

class bankList: NSObject {
    var bankName : String!
    var bankId : String!
    func initWith(_ dictionary : NSDictionary) -> bankList {
        bankName = dictionary["name"] != nil ? dictionary["name"] as! String : ""
        bankId = dictionary["code"] != nil ? dictionary["code"] as! String : ""
        return self
    }
    
}

public class User {
    
    public var user_details : UserDetails?
    public var user_pic_url : String?
    public var user_pic_url_100 : String?
    public var user_pic_url_200 : String?
    public var access_token : String?
    
    class var current: User {
        struct Singleton {
            static let current = User()
        }
        return Singleton.current
    }
    
    func initWithDictionary(dictionary: NSDictionary) {
        user_pic_url = dictionary["user_pic_url"] as? String
        user_pic_url_100 = dictionary["user_pic_url_100"] as? String
        user_pic_url_200 = dictionary["user_pic_url_200"] as? String
        access_token = dictionary["access_token"] as? String
        user_details = UserDetails().initWith(dictionary["user_details"] as! NSDictionary)
        
    }
    
    public func dictionaryRepresentation() -> NSDictionary {
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.user_pic_url, forKey: "user_pic_url")
        dictionary.setValue(self.user_pic_url_100, forKey: "user_pic_url_100")
        dictionary.setValue(self.user_pic_url_200, forKey: "user_pic_url_200")
        dictionary.setValue(self.access_token, forKey: "access_token")
        
        return dictionary
    }
    
    //MARK:- STORE USER DATA
    
    public class func saveLoggedUserdetails(dictDetails : NSDictionary){
        let data : NSData = NSKeyedArchiver.archivedData(withRootObject: dictDetails) as NSData
        UserDefaults.standard.set(data, forKey: "CurrentUserDetails")
        UserDefaults.standard.synchronize()
    }
    
    //MARK:- Delete Current User
    
    public class func logOutCurrentUser(){
       User.current.user_details = nil
       User.current.user_pic_url = nil
       User.current.user_pic_url_100 = nil
       User.current.user_pic_url_200 = nil
        User.current.access_token = nil
        let appDomain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: appDomain)
    }
    
}

public class UserDetails: NSObject {
    var u_first_name : String!
    var u_image : String!
    var u_id : Int!
    var wallet_balance : Int?
    
    func initWith(_ dictionary : NSDictionary)-> UserDetails {
        u_first_name = dictionary["u_first_name"] != nil ? dictionary["u_first_name"] as! String  : ""
        u_image = dictionary["u_image"] != nil ? dictionary["u_image"] as! String  : ""
        u_id = dictionary["u_id"] != nil ? dictionary["u_id"] as! Int  : 0
        wallet_balance = dictionary["wallet_balance"] != nil ? dictionary["wallet_balance"] as! Int : 0
        return self
    }
    
}

public class WalletBalance: NSObject {
    var balance : String!
    
    func initWith(_ dictionary : NSDictionary)-> WalletBalance {
        balance = dictionary["balance"] != nil ? dictionary["balance"] as! String  : ""
        return self
    }
    
}

public class DriverDetails : NSObject {
    
    var driver_id : Int!
    var first_name : String!
    var last_name   : String!
    var email       : String!
    var institution_name : String!
    var phone       : String!
    var institution_id : Int!
    var phone_country  : String!
    var vehicle_no  : String!
    var verified : Int!
    var u_device_id : String!
    var gender : String!
    var car_model : String!
    var trip_id: Int!
    var car_capacity: Int!
    var license_no : String!
    var license_expiry : String!
    var ride_id: Int!
    var dob : String!
    var ratings : Double!
    var driver : NSDictionary!
    var distance_to_drive_details : DistanceToDriver!
    var wallet_balance : String!
    var image : String!
    
    func initWith(dictionary: NSDictionary)-> DriverDetails {
        trip_id = dictionary["trip_id"]        is NSNull ? 0 : dictionary["trip_id"]     != nil ? dictionary["trip_id"] as! Int : 0
        //dictionary["trip_id"] != nil ? dictionary["trip_id"] as! Int : 0
        
        
        ride_id = dictionary["ride_id"]        is NSNull ? 0 : dictionary["ride_id"]     != nil ? dictionary["ride_id"] as! Int : 0
        //dictionary["ride_id"] != nil ? dictionary["ride_id"] as! Int : 0
        
        
        driver = dictionary["driver_details"]        is NSNull ? [:] : dictionary["driver_details"]     != nil ? dictionary["driver_details"] as! NSDictionary : [:]
        //dictionary["driver_details"] != nil ? dictionary["driver_details"] as! NSDictionary : [:]
        
        
        distance_to_drive_details = DistanceToDriver.init().initWith(dictionary["distance_to_drive_details"] as! NSDictionary)
        
        
        driver_id = driver["driver_id"]        is NSNull ? 0 : driver["driver_id"]     != nil ? driver["driver_id"] as! Int : 0
        //driver["driver_id"] != nil ? driver["driver_id"] as! Int : 0
        
        
        first_name = driver["first_name"]        is NSNull ? "" : driver["first_name"]     != nil ? driver["first_name"] as! String : ""
        //driver["first_name"] != nil ? driver["first_name"] as! String : ""
        
        
        last_name = driver["last_name"]        is NSNull ? "" : driver["last_name"]     != nil ? driver["last_name"] as! String : ""
        //driver["last_name"] != nil ? driver["last_name"] as! String : ""
        
        
        email = driver["email"]        is NSNull ? "" : driver["email"]     != nil ? driver["email"] as! String : ""// driver["email"] != nil ? driver["email"] as! String : ""
        
        
        institution_id = driver["institution_id"]        is NSNull ? 0 : driver["institution_id"]     != nil ? driver["institution_id"] as! Int : 0
        //driver["institution_id"] != nil ? driver["institution_id"] as! Int : 0
        
        institution_name = driver["institution_name"]        is NSNull ? "" : driver["institution_name"]     != nil ? driver["institution_name"] as! String : ""
        //institution_name = driver["institution_name"] != nil ? driver["institution_name"] as! String : ""
        
        phone = driver["phone"]        is NSNull ? "" : driver["phone"]     != nil ? driver["phone"] as! String : ""
        //driver["phone"] != nil ? driver["phone"] as! String : ""
        
        
        phone_country = driver["phone_country"]        is NSNull ? "" : driver["phone_country"]     != nil ? driver["phone_country"] as! String : ""
        //driver["phone_country"] != nil ? driver["phone_country"] as! String : ""
        
        
        gender = driver["gender"]        is NSNull ? "" : driver["gender"]     != nil ? driver["gender"] as! String : ""
        //driver["gender"] != nil ? driver["gender"] as! String : ""
        
        
        vehicle_no = driver["vehicle_no"]        is NSNull ? "" : driver["vehicle_no"]     != nil ? driver["vehicle_no"] as! String : ""
        //driver["vehicle_no"] != nil ? driver["vehicle_no"] as! String : ""
        
        
        verified = driver["verified"]        is NSNull ? 0 : driver["verified"]     != nil ? driver["verified"] as! Int : 0
        //driver["verified"] != nil ? driver["verified"] as! Int : 0
        
        
        u_device_id = driver["u_device_id"]        is NSNull ? "" : driver["u_device_id"]     != nil ? driver["u_device_id"] as! String : ""
        //driver["u_device_id"] != nil ? driver["u_device_id"] as! String : ""
        
        
        car_model = driver["car_model"]        is NSNull ? "" : driver["car_model"]     != nil ? driver["car_model"] as! String : ""
        //driver["car_model"] != nil ? driver["car_model"] as! String : ""
        
        
        car_capacity = driver["car_capacity"]        is NSNull ? 0 : driver["car_capacity"]     != nil ? driver["car_capacity"] as! Int : 0
        //driver["car_capacity"] != nil ? driver["car_capacity"] as! String : ""
        
        
        license_no = driver["license_no"]        is NSNull ? "" : driver["license_no"]     != nil ? driver["license_no"] as! String : ""
        //driver["license_no"] != nil ? driver["license_no"] as! String : ""
        
        
        license_expiry = driver["license_expiry"]        is NSNull ? "" : driver["license_expiry"]     != nil ? driver["license_expiry"] as! String : ""
        //driver["license_expiry"] != nil ? driver["license_expiry"] as! String : ""
        
        
        dob = driver["dob"]        is NSNull ? "" : driver["dob"]     != nil ? driver["dob"] as! String : ""
            //driver["dob"] != nil ? driver["dob"] as! String : ""
        
        
        ratings = driver["ratings"]        is NSNull ? 0 : driver["ratings"]     != nil ? driver["ratings"] as! Double : 0
        //driver["ratings"] != nil ? driver["ratings"] as! Int : 0
        
        
        wallet_balance = driver["wallet_balance"]        is NSNull ? "" : driver["wallet_balance"]     != nil ? driver["wallet_balance"] as! String : ""
        //driver["wallet_balance"] != nil ? driver["wallet_balance"] as! String : ""
        
        
        image = driver["image"]        is NSNull ? "" : driver["image"]     != nil ? driver["image"] as! String : ""
        //driver["image"] != nil ? driver["image"] as! String : ""
        
        return self
    }
    
}




public class DistanceToDriver : NSObject {
    var distance : String!
    var time : String!
    func initWith(_ dictionary: NSDictionary) ->DistanceToDriver  {
       distance =  dictionary["distance"]        is NSNull ? "" : dictionary["distance"]     != nil ? dictionary["distance"] as! String : ""
        time =  dictionary["time"]        is NSNull ? "" : dictionary["time"]     != nil ? dictionary["time"] as! String : ""
        return self
        
    }
}




