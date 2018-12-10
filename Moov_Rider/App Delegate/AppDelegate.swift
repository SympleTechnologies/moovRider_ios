//
//  AppDelegate.swift
//  Moov_Rider
//
//  Created by Visakh on 17/07/18.
//  Copyright © 2018 Visakh. All rights reserved.
//

import UIKit
import CoreData
import GooglePlaces
import GoogleMaps
import UserNotifications
import Paystack
import GoogleSignIn
import FBSDKLoginKit
import AVFoundation
import Firebase
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate, UNUserNotificationCenterDelegate {
   
    var window: UIWindow?
    var storyboard : UIStoryboard!
    var pushToken = ""
    var deviceTokenStr: String!
    //"240444611110-84o3ivgt49kibaj7ovgda325h7n4ht3u.apps.googleusercontent.com"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.storyboard = UIStoryboard(name: "Main", bundle: nil)
        GIDSignIn.sharedInstance().clientID = "240444611110-84o3ivgt49kibaj7ovgda325h7n4ht3u.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //        DispatchQueue.main.async {
        //            if #available(iOS 10.0, *) {
        //                UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
        //            } else {
        //                // Fallback on earlier versions
        //            }
        //            UIApplication.shared.registerForRemoteNotifications()
        //        }
        
        Paystack.setDefaultPublicKey("pk_test_1544ffee69407a91be7cece08566ea4ca1343126")
        GMSPlacesClient.provideAPIKey("AIzaSyCffuKbSaxLy3_poqYGLjIFo2CMneLFCoM")
        GMSServices.provideAPIKey("AIzaSyCffuKbSaxLy3_poqYGLjIFo2CMneLFCoM")
        if (UserDefaults.standard.object(forKey: "CurrentUserDetails") != nil){
            let dict:NSDictionary = NSKeyedUnarchiver.unarchiveObject(with: (UserDefaults.standard.object(forKey: "CurrentUserDetails") as! NSData) as Data) as! NSDictionary
            User.current.initWithDictionary(dictionary: dict)
            setRootToMain()
        }else {
            setRootToLogin()
        }
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }
        } else {
            // Fallback on earlier versions
            let settings = UIUserNotificationSettings(types:  [.badge, .alert, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            UIApplication.shared.registerForRemoteNotifications()
        }
        
        
        return true
    }
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation) || GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
   
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
            // [START_EXCLUDE silent]
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: "ToggleAuthUINotification"), object: nil, userInfo: nil)
            // [END_EXCLUDE]
        } else {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            // [START_EXCLUDE]
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: "ToggleAuthUINotification"),
                object: nil,
                userInfo: ["statusText": "Signed in user:\n\(fullName)"])
            // [END_EXCLUDE]
        }
    }
    
    func setRootToMain(){
        let homePage = self.storyboard.instantiateViewController(withIdentifier: "EnterDestinationViewController")
            as! EnterDestinationViewController
        let navVC = UINavigationController(rootViewController: homePage)
        let sideVC = self.storyboard.instantiateViewController(withIdentifier: "SideMenuTableViewController") as! SideMenuTableViewController
        let mfContainer = MFSideMenuContainerViewController.container(withCenter: navVC, leftMenuViewController: sideVC, rightMenuViewController: nil)
        self.window?.rootViewController = mfContainer
        self.window?.makeKeyAndVisible()
    }
    
    func setRootToLogin(){
        let LoginTableVC = self.storyboard.instantiateViewController(withIdentifier: "LandingPageViewController") as! LandingPageViewController
        let navVC = UINavigationController(rootViewController: LoginTableVC)
        self.window?.rootViewController = navVC
        self.window?.makeKeyAndVisible()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        deviceTokenStr = tokenString
        print("deviceToken : \(deviceTokenStr!)")
        UserDefaults.standard.set(deviceTokenStr, forKey: "deviceToken")
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
        
        let state: UIApplicationState = UIApplication.shared.applicationState
        if state == .active {
            let systemSoundID: SystemSoundID = 1007
            AudioServicesPlaySystemSound(systemSoundID)
        
        let aps = userInfo["aps"] as! NSDictionary
        if aps["title"] as! String == "Ride Started"{
            if application.applicationState == .active {
                NotificationCenter.default.post(name: Notification.Name("didReceiveRemoteNotification"), object: nil, userInfo: userInfo)
                print("deviceToken")
            }
        }else if aps["title"] as! String == "Ride booked"{
                if application.applicationState == .active {
                    NotificationCenter.default.post(name: Notification.Name("didReceiveRemoteNotificationforFutureRide"), object: nil, userInfo: userInfo)
                    print("deviceToken")
                }
            }
        else{
            if application.applicationState == .active {
                NotificationCenter.default.post(name: Notification.Name("didReceiveRemoteNotificationforstopride"), object: nil, userInfo: userInfo)
                print("deviceToken")
            }
        }
        }
    
    }
    @available(iOS 10.0, *)
    @available(iOS 10.0, *)
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        let userInfo = notification.request.content.userInfo as? NSDictionary
        let aps = userInfo!["aps"] as? NSDictionary
        if aps!["title"] as? String == "Ride Started" {
            NotificationCenter.default.post(name: Notification.Name("didReceiveRemoteNotification"), object: nil, userInfo: userInfo as? [AnyHashable : Any])
            print("deviceToken")
        }else if aps!["title"] as? String == "Ride booked" {
            NotificationCenter.default.post(name: Notification.Name("didReceiveRemoteNotificationforFutureRide"), object: nil, userInfo: userInfo as? [AnyHashable : Any])
            print("deviceToken")
        }
        else {
            NotificationCenter.default.post(name: Notification.Name("didReceiveRemoteNotificationforstopride"), object: nil, userInfo: userInfo as? [AnyHashable : Any])
        }
        completionHandler([.alert, .badge, .sound])
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    @available(iOS 10.0, *)
    @available(iOS 10.0, *)
    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Moov_Rider")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
            let context = persistentContainer.viewContext
       
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

