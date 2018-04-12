//
//  GPSTrackerViewController.swift
//  GPSTracker
//
//  Created by Sensu Soft on 25/12/17.
//  Copyright © 2017 Sensu Soft. All rights reserved.
//

import UIKit
import MapKit

class GPSTrackerViewController: UIViewController,LocationServiceDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var btnStart: UIButton!
    
    @IBOutlet weak var btn1min: UIButton!
    @IBOutlet weak var btn5min: UIButton!
    @IBOutlet weak var btn15min: UIButton!
    @IBOutlet weak var btnLogout: UIButton!
    
    var timer = Timer()
    var timeDouble:Double = 60
    var previousLocation:CLLocation!
    var totalDistanceInMeters:Double = 0
    var taskModel = TaskListModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        doSetupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.hidesBackButton = true
        
        let btnback = UIButton(type: .custom)
        btnback.setImage(UIImage(named: "ic_back"), for: .normal)
        btnback.frame = CGRect(x: -10, y: 0, width: 30, height: 30)
        btnback.showsTouchWhenHighlighted = true
        btnback.addTarget(self, action: #selector(self.btnback_Click), for: .touchUpInside)
        let leftBarButtonItems = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        leftBarButtonItems.addSubview(btnback)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBarButtonItems)
    }
    
    func btnback_Click() {
        _ = self.navigationController?.popViewController(animated: true)
    }

    func doSetupUI() {
        self.title = "GPS Tracker"
        btnStart.isSelected = false
        btnStart.backgroundColor = APP_BLUE_COLOR
        btnStart.setTitle("Start", for: .normal)
        
        btn1min.setImage(ImageNamed("unselect"), for: .normal)
        btn1min.setImage(ImageNamed("select"), for: .selected)
        btn1min.isSelected = true
        
        btn5min.setImage(ImageNamed("unselect"), for: .normal)
        btn5min.setImage(ImageNamed("select"), for: .selected)
        btn5min.isSelected = false
        
        btn15min.setImage(ImageNamed("unselect"), for: .normal)
        btn15min.setImage(ImageNamed("select"), for: .selected)
        btn15min.isSelected = false
        
        LocationService.sharedInstance.delegate = self
        
        btnLogout.setTitle("Logout", for: .normal)
        btnLogout.backgroundColor = APP_ORANGE_COLOR
        
    }
    
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: timeDouble, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
    }
    
    func updateCounting(){
        NSLog("counting..")
        LocationService.sharedInstance.stopUpdatingLocation()
        LocationService.sharedInstance.startUpdatingLocation()
    }
    
    func callAPIforUpdateTask(action: String) {
         //“Action” : “1”   (1 when start, 0 when close )
        var param = [String:AnyObject]()
        param["TaskId"] = taskModel.TaskId as AnyObject
        param["ClientId"] = taskModel.ClientId as AnyObject
        param["StaffId"] = taskModel.StaffId as AnyObject
        param["Action"] = action as AnyObject
        print(param)
       ServiceManager.apiUpdateTask(param) { (isSuccess, msg) in
            if(isSuccess){
                displayAlertWithMessage(msg)
            }
        }

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
        param["TaskId"] = taskModel.TaskId as AnyObject
        param["ClientId"] = taskModel.ClientId as AnyObject
        param["StaffId"] = taskModel.StaffId as AnyObject

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
    
    //MARK:- Button Action Method
    @IBAction func btnStartAction(_ sender: UIButton) {
        
        if(sender.isSelected){
            //Stop Location
            sender.isSelected = false
            sender.backgroundColor = APP_BLUE_COLOR
            sender.setTitle("Start", for: .normal)
            appDelegate.isFromStart = false
            LocationService.sharedInstance.stopUpdatingLocation()
            timer.invalidate()
            self.callAPIforUpdateTask(action: "0")
            
        }else{
            // Start Location
            sender.isSelected = true
            sender.backgroundColor = APP_ORANGE_COLOR
            sender.setTitle("Stop", for: .normal)
            appDelegate.isFromStart = true
            LocationService.sharedInstance.stopUpdatingLocation()
            LocationService.sharedInstance.startUpdatingLocation()
            self.scheduledTimerWithTimeInterval()
            self.callAPIforUpdateTask(action: "1")
        }
        
    }
    @IBAction func btnLogoutAction(_ sender: Any) {
        timer.invalidate()
        AIUser.sharedManager.logout()
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewContoller") as! LoginViewContoller
        self.navigationController?.pushViewController(VC, animated: true)
        
    }
    
    @IBAction func btnUpdateAction(_ sender: UIButton) {
        if sender.tag == 0 {
            if(sender.isSelected){
                //sender.isSelected = false
            }else{
                sender.isSelected = true
                btn5min.isSelected = false
                btn15min.isSelected = false
                print("select 1 min")
                timeDouble = 60
                timer.invalidate()
                self.scheduledTimerWithTimeInterval()
            }
        }
        
        if sender.tag == 1 {
            if(sender.isSelected){
                //sender.isSelected = false
            }else{
                sender.isSelected = true
                btn1min.isSelected = false
                btn15min.isSelected = false
                print("select 5 min")
                timeDouble = 300
                timer.invalidate()
                self.scheduledTimerWithTimeInterval()
            }
        }
        
        if sender.tag == 2 {
            if(sender.isSelected){
                //sender.isSelected = false
            }else{
                sender.isSelected = true
                btn1min.isSelected = false
                btn5min.isSelected = false
                print("select 15 min")
                timeDouble = 900
                timer.invalidate()
                self.scheduledTimerWithTimeInterval()
            }
            
        }
    }
    
    //MARK:- Delegate Method
    func tracingLocation(currentLocation: CLLocation) {
        getAdressName(coords: currentLocation)
    }

    func tracingLocationDidFailWithError(error: NSError) {
        displayAlertWithMessage("The operation couldn’t be completed, go to setting and please enable location.")
    }
}
