//
//  AppDelegate.swift
//  GPSTracker
//
//  Created by Sensu Soft on 23/12/17.
//  Copyright © 2017 Sensu Soft. All rights reserved.
//

import UIKit
import MapKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,LocationServiceDelegate {

    var window: UIWindow?
    var navigationController:UINavigationController?
    var timer = Timer()
    var previousLocation:CLLocation!
    var totalDistanceInMeters:Double = 0
    var backgroundTaskIdentifier: UIBackgroundTaskIdentifier?
    var isFromStart:Bool = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UINavigationBar.appearance().barTintColor = APP_BLUE_COLOR
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        LocationService.sharedInstance.startUpdatingLocation()
        
        if(AIUser.sharedManager.isLoggedin()){
            //Home
//            let vc = storyBoard.instantiateViewController(withIdentifier: "GPSTrackerViewController") as! GPSTrackerViewController
//            self.navigationController = UINavigationController(rootViewController: vc)
//            self.navigationController?.setNavigationBarHidden(false, animated: false)
//            self.window?.rootViewController = self.navigationController
//            self.window?.makeKeyAndVisible()
            
            let vc = storyBoard.instantiateViewController(withIdentifier: "TaskListViewController") as! TaskListViewController
            self.navigationController = UINavigationController(rootViewController: vc)
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            self.window?.rootViewController = self.navigationController
            self.window?.makeKeyAndVisible()
        }
        else{
            // login
            let vc = storyBoard.instantiateViewController(withIdentifier:"LoginViewContoller")as! LoginViewContoller
            self.navigationController = UINavigationController(rootViewController: vc)
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            self.window?.rootViewController = self.navigationController
            self.window?.makeKeyAndVisible()
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
       
        backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            UIApplication.shared.endBackgroundTask(self.backgroundTaskIdentifier!)
            
        })
        
        print("Backgroud")
        
         if(AIUser.sharedManager.isLoggedin()){
            if(isFromStart){
                self.scheduledTimerWithTimeInterval()
            }
            
        }
        
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        timer.invalidate()
        print("FOREGROUD")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
    }
    

    func updateCounting(){
        NSLog("counting..")
        LocationService.sharedInstance.stopUpdatingLocation()
        LocationService.sharedInstance.startUpdatingLocation()
    }
    
    func callApiForUpdateLocation(currentLocation: CLLocation, strAddress:String) {
        if(previousLocation != nil){
            let distant = currentLocation.distance(from: previousLocation)
            totalDistanceInMeters = totalDistanceInMeters + distant
            previousLocation = currentLocation
        }
        
        var param = [String:AnyObject]()
        param["latitude"] = currentLocation.coordinate.latitude as AnyObject
        param["longitude"] = currentLocation.coordinate.longitude as AnyObject
        param["user_name"] = AIUser.sharedManager.display_name as AnyObject
        param["phone_number"] = UUID().uuidString.uppercased() as AnyObject
        param["session_id"] = UUID().uuidString.uppercased() as AnyObject
        param["speed"] = currentLocation.speed as AnyObject
        param["direction"] = currentLocation.course as AnyObject
        param["distance"] = totalDistanceInMeters as AnyObject
        param["location_method"] = "n/a" as AnyObject
        param["accuracy"] = currentLocation.horizontalAccuracy as AnyObject
        param["extra_info"] = currentLocation.altitude as AnyObject
        param["event_type"] = "ios" as AnyObject
        param["gps_time"] = currentLocation.timestamp as AnyObject
        param["address"] = strAddress as AnyObject
        
        print(param)
        ServiceManager.apiUpdateLocationWithParameters(param) { (isSuccess) in
            
        }
    }
    
    func getAdressName(coords: CLLocation) {
        
        CLGeocoder().reverseGeocodeLocation(coords) { (placemark, error) in
            if error != nil {
                self.callApiForUpdateLocation(currentLocation: coords, strAddress: "")
                print("Hay un error")
                
            } else {
                
                let place = placemark! as [CLPlacemark]
                
                if place.count > 0 {
                    let place = placemark![0]
                    
                    var adressString : String = ""
                    
                    if place.thoroughfare != nil {
                        adressString = adressString + place.thoroughfare! + ", "
                    }
                    if place.subThoroughfare != nil {
                        adressString = adressString + place.subThoroughfare! + " "
                    }
                    if place.locality != nil {
                        adressString = adressString + place.locality! + " - "
                    }
                    if place.postalCode != nil {
                        adressString = adressString + place.postalCode! + " "
                    }
                    if place.subAdministrativeArea != nil {
                        adressString = adressString + place.subAdministrativeArea! + " - "
                    }
                    if place.country != nil {
                        adressString = adressString + place.country!
                    }
                    print(adressString)
                    self.callApiForUpdateLocation(currentLocation: coords, strAddress: adressString)
                }
                
            }
        }
    }
    
    
    //MARK:- Delegate Method
    func tracingLocation(currentLocation: CLLocation) {
        getAdressName(coords: currentLocation)
    }
    
    func tracingLocationDidFailWithError(error: NSError) {
        //displayAlertWithMessage("The operation couldn’t be completed, go to setting and please enable location.")
    }

}

