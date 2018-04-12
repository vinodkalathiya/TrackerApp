//
//  LocationService.swift
//
//


import Foundation
import CoreLocation

protocol LocationServiceDelegate {
    func tracingLocation(currentLocation: CLLocation)
    func tracingLocationDidFailWithError(error: NSError)
}

class LocationService: NSObject, CLLocationManagerDelegate {
    
    static let sharedInstance : LocationService = {
        let instance = LocationService()
        return instance
    }()
    
    
    var locationManager: CLLocationManager?
    var currentLocation: CLLocation?
    var delegate: LocationServiceDelegate?
    var timer = Timer()
    
    override init() {
        super.init()
        
        self.locationManager = CLLocationManager()
        guard let locationManager = self.locationManager else {
            return
        }
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            // you have 2 choice
            // 1. requestAlwaysAuthorization
            // 2. requestWhenInUseAuthorization
            locationManager.requestAlwaysAuthorization()
        }
        
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest // The accuracy of the location data
//        locationManager.distanceFilter = 200 // The minimum distance (measured in meters) a device must move horizontally before an update event is generated.
//        locationManager.pausesLocationUpdatesAutomatically = false
//        
//        if #available(iOS 9.0, *) {
//            locationManager.allowsBackgroundLocationUpdates = true
//        } else {
//            // Fallback on earlier versions
//        }
        
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        locationManager.distanceFilter = 0; // meters
        //locationManager.pausesLocationUpdatesAutomatically = NO; // YES is default
        locationManager.activityType = .automotiveNavigation
        
        
        locationManager.delegate = self
        locationManager.startUpdatingLocation()

    }
    
    func startUpdatingLocation() {
        print("Starting Location Updates")
        self.locationManager?.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        print("Stop Location Updates")
        self.locationManager?.stopUpdatingLocation()
    }
    
    // CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        
        // singleton for get last(current) location
        self.currentLocation = location
        
//        DispatchQueue.global(qos: .background).async {
//            print("This is run on the background queue")
//            self.apiCallForCurrentLocation()
//        }
        
        // use for real time update location
        updateLocation(currentLocation: location)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // do on error
        updateLocationDidFailWithError(error: error as NSError)
    }
    
    // Private function
    private func updateLocation(currentLocation: CLLocation){
        
        guard let delegate = self.delegate else {
            return
        }
        
        delegate.tracingLocation(currentLocation: currentLocation)
    }
    
    private func updateLocationDidFailWithError(error: NSError) {
        
        guard let delegate = self.delegate else {
            return
        }
        
        delegate.tracingLocationDidFailWithError(error: error)
    }
}
