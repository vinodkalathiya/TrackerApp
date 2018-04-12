
//
//  AIUtilsManager.swift
//  Swift3CodeStructure
//
//  Created by Ravi Alagiya on 25/11/2016.
//  Copyright © 2016 Ravi Alagiya. All rights reserved.
//

import Foundation
import UIKit

let CUSTOM_ERROR_DOMAIN = "CUSTOM_ERROR_DOMAIN"
let CUSTOM_ERROR_USER_INFO_KEY = "CUSTOM_ERROR_USER_INFO_KEY"

// MARK: - INTERNET CHECK

func IS_INTERNET_AVAILABLE() -> Bool{
    return AIReachabilityManager.sharedManager.isInternetAvailableForAllNetworks()
}

func SHOW_INTERNET_ALERT(){
    HIDE_CUSTOM_LOADER()
    HIDE_NETWORK_ACTIVITY_INDICATOR()
    
    displayAlertWithTitle(APP_NAME, andMessage: "Please check your internet connection and try again.", buttons: ["Dismiss"], completion: nil)
    
}

// MARK: - ALERT
func displayAlertWithMessage(_ message:String) -> Void {
    displayAlertWithTitle(APP_NAME, andMessage: message, buttons: ["Dismiss"], completion: nil)
}


func displayAlertWithMessageFromVC(_ vc:UIViewController, message:String, buttons:[String], completion:((_ index:Int) -> Void)!) -> Void {
    
    let alertController = UIAlertController(title: APP_NAME, message: message, preferredStyle: .alert)
    
    for index in 0..<buttons.count	{
        
        alertController.setValue(NSAttributedString(string: APP_NAME, attributes: [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 16),NSForegroundColorAttributeName : APP_BLACK_COLOR]), forKey: "attributedTitle")
        
        alertController.setValue(NSAttributedString(string: message, attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 14),NSForegroundColorAttributeName : APP_BLACK_COLOR]), forKey: "attributedMessage")
        
        
        let action = UIAlertAction(title: buttons[index], style: .default, handler: {
            (alert: UIAlertAction!) in
            if(completion != nil){
                completion(index)
            }
        })
        
        action.setValue(UIColor.black, forKey: "titleTextColor")
        alertController.addAction(action)
    }
    
    vc.present(alertController, animated: true, completion: nil)
}

func displayAlertWithTitle(_ title:String, andMessage message:String, buttons:[String], completion:((_ index:Int) -> Void)!) -> Void {
    
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    for index in 0..<buttons.count	{
        
        alertController.setValue(NSAttributedString(string: title, attributes: [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 16),NSForegroundColorAttributeName : APP_BLACK_COLOR]), forKey: "attributedTitle")
        
        alertController.setValue(NSAttributedString(string: message, attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 14),NSForegroundColorAttributeName : APP_BLACK_COLOR]), forKey: "attributedMessage")
        
        
        let action = UIAlertAction(title: buttons[index], style: .default, handler: {
            (alert: UIAlertAction!) in
            if(completion != nil){
                completion(index)
            }
        })
        
        action.setValue(UIColor.black, forKey: "titleTextColor")
        alertController.addAction(action)
    }
    UIApplication.shared.delegate!.window!?.rootViewController!.present(alertController, animated: true, completion:nil)
}


func displayAlertWithTitle(_ vc:UIViewController, title:String, andMessage message:String, buttons:[String], completion:((_ index:Int) -> Void)!) -> Void {
    
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    for index in 0..<buttons.count	{
        
        alertController.setValue(NSAttributedString(string: title, attributes: [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 16),NSForegroundColorAttributeName : APP_BLACK_COLOR]), forKey: "attributedTitle")
        
        alertController.setValue(NSAttributedString(string: message, attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 14),NSForegroundColorAttributeName : APP_BLACK_COLOR]), forKey: "attributedMessage")
        
        
        let action = UIAlertAction(title: buttons[index], style: .default, handler: {
            (alert: UIAlertAction!) in
            if(completion != nil){
                completion(index)
            }
        })
        
        action.setValue(UIColor.black, forKey: "titleTextColor")
        alertController.addAction(action)
    }
    vc.present(alertController, animated: true, completion: nil)
}

//MARK:- CUSTOM LOADER

func SHOW_NETWORK_ACTIVITY_INDICATOR(){
    UIApplication.shared.isNetworkActivityIndicatorVisible =  true
}

func HIDE_NETWORK_ACTIVITY_INDICATOR(){
    UIApplication.shared.isNetworkActivityIndicatorVisible =  false
}


// MARK: - DATE MERGING

func combineDateWithTime(date: NSDate, time: NSDate) -> NSDate? {
    let calendar = NSCalendar.current
    
    let dateComponents = calendar.dateComponents([.year,.month,.day], from: date as Date)
    
    let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: time as Date)
    
    let mergedComponments = NSDateComponents()
    mergedComponments.year = dateComponents.year!
    mergedComponments.month = dateComponents.month!
    mergedComponments.day = dateComponents.day!
    mergedComponments.hour = timeComponents.hour!
    mergedComponments.minute = timeComponents.minute!
    mergedComponments.second = timeComponents.second!
    
    return calendar.date(from: mergedComponments as DateComponents) as NSDate?
}

// MARK:-  DATE STRING TO DATE TYPE CASTING //Formate : "yyyy-MM-dd'T'HH:mm:ssZ"

func appStringTODateConvert(strDate:String)-> String{
    let dateFormatter = DateFormatter()
    let tempLocale = dateFormatter.locale // save locale temporarily
    dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"  // "yyyy-MM-dd'T'HH:mm:ss.SSSZZ

    guard let date = dateFormatter.date(from: strDate) else {
        return appStringTODateConvertAnotherFormate(dateString: strDate)
    }

    dateFormatter.dateFormat = "MM/dd/yyyy"
    dateFormatter.locale = tempLocale // reset the locale
    let dateString = dateFormatter.string(from: date)
    
    return dateString.isEmpty ? "" : dateString
    
}

func appStringTODateConvertAnotherFormate(dateString:String)-> String{
    
    let dateFormatter = DateFormatter()
    let tempLocale = dateFormatter.locale // save locale temporarily
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    
    guard let date = dateFormatter.date(from: dateString) else {
        return ""
    }
    
    dateFormatter.dateFormat = "MM/dd/yyyy"
    dateFormatter.locale = tempLocale // reset the locale
    let dateString = dateFormatter.string(from: date)
    return dateString.isEmpty ? "" : dateString
    
}

func gateStringToDate(strDate:String) -> Date{
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    
    guard let date = dateFormatter.date(from: strDate) else {

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        guard let date1 = dateFormatter.date(from: strDate) else {
            return Date()
        }
        return date1
    }
    return date
}

func getOffsetFromCurrentDate(strDate:String) -> String {
    var returnValue = ""
    
    let dateCheck = gateStringToDate(strDate: strDate)
    
    let differenceComponent = NSCalendar.current.dateComponents([.second, .minute, .hour, .day, .month, .year], from: dateCheck, to: NSDate() as Date)

    
    if differenceComponent.year! > 0 || differenceComponent.month! > 0 || differenceComponent.day! > 2{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        returnValue = dateFormatter.string(from: dateCheck)
        
    }else if differenceComponent.day! <= 2{
        if differenceComponent.day == 1 {
            returnValue = "1d"
        }else{
            returnValue = String(format: "%dd", differenceComponent.day!)
        }
        
    }else if differenceComponent.hour! > 0{
        if differenceComponent.hour == 1 {
            returnValue = "1h"
        }else{
            returnValue = String(format: "%dh", differenceComponent.hour!)
        }
    }else if differenceComponent.minute! > 0{
        if differenceComponent.minute == 1 {
            returnValue = "1m"
        }else{
            returnValue = String(format: "%dm", differenceComponent.minute!)
        }
    }else if differenceComponent.second! >= 0{
        //returnValue = "Just Now"
            if differenceComponent.second == 1 {
                returnValue = "1s"
            }else{
                returnValue = String(format: "%ds", differenceComponent.second!)
            }
    }
    
    return returnValue
}


//MARK:- DEVICE CHECK


//Check IsiPhone Device
func IS_IPHONE_DEVICE()->Bool{
    let deviceType = UIDevice.current.userInterfaceIdiom == .phone
    return deviceType
}

//Check IsiPad Device
func IS_IPAD_DEVICE()->Bool{
    let deviceType = UIDevice.current.userInterfaceIdiom == .pad
    return deviceType
}


//iPhone 4 OR 4S
func IS_IPHONE_4_OR_4S()->Bool{
    let SCREEN_HEIGHT_TO_CHECK_AGAINST:CGFloat = 480
    var device:Bool = false
    
    if(SCREEN_HEIGHT_TO_CHECK_AGAINST == SCREEN_HEIGHT)	{
        device = true
    }
    return device
}

//iPhone 5 OR OR 5C OR 4S
func IS_IPHONE_5_OR_5S()->Bool{
    let SCREEN_HEIGHT_TO_CHECK_AGAINST:CGFloat = 568
    var device:Bool = false
    if(SCREEN_HEIGHT_TO_CHECK_AGAINST == SCREEN_HEIGHT)	{
        device = true
    }
    return device
}

//iPhone 6 OR 6S
func IS_IPHONE_6_OR_6S()->Bool{
    let SCREEN_HEIGHT_TO_CHECK_AGAINST:CGFloat = 667
    var device:Bool = false
    
    if(SCREEN_HEIGHT_TO_CHECK_AGAINST == SCREEN_HEIGHT)	{
        device = true
    }
    return device
}

//iPhone 6Plus OR 6SPlus
func IS_IPHONE_6P_OR_6SP()->Bool{
    let SCREEN_HEIGHT_TO_CHECK_AGAINST:CGFloat = 736
    var device:Bool = false
    
    if(SCREEN_HEIGHT_TO_CHECK_AGAINST == SCREEN_HEIGHT)	{
        device = true
    }
    return device
}

//MARK:- DEVICE ORIENTATION CHECK
func IS_DEVICE_PORTRAIT() -> Bool {
    return UIDevice.current.orientation.isPortrait
}

func IS_DEVICE_LANDSCAPE() -> Bool {
    return UIDevice.current.orientation.isLandscape
}

