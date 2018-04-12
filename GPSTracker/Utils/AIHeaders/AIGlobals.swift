//
//  AIGlobals.swift
//  Swift3CodeStructure
//
//  Created by Ravi Alagiya on 25/11/2016.
//  Copyright © 2016 Ravi Alagiya. All rights reserved.
//

import Foundation
import UIKit


//MARK: - GENERAL
let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate

//MARK: - MANAGERS
let ServiceManager = AIServiceManager.sharedManager
//let UserManager = AIUser.sharedManager

//MARK: - APP SPECIFIC
let APP_NAME = "G P S Tracker"

let storyBoard = UIStoryboard(name: "Main", bundle: nil)

func getStringFromDictionary(_ dict:AnyObject) -> String{
	var strJson = ""
	do {
		let data = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
		strJson = String(data: data, encoding: String.Encoding.utf8)!
	} catch let error as NSError {
		print("json error: \(error.localizedDescription)")
	}
	return strJson
}

//MARK: - KEYS
let KEY_IS_USER_LOGGED_IN = "KEY_IS_USER_LOGGED_IN"
let AIUSER_CURRENTUSER_STORE = "AIUSER_CURRENTUSER_STORE"

//MARK: - IMAGE
func ImageNamed(_ name:String) -> UIImage?{
	return UIImage(named: name)
}


//MARK: - COLORS
let APP_PRIMARY_COLOR       = UIColor(red: 98/255, green: 52/255, blue: 125/255, alpha: 1)
let APP_SECONDARY_COLOR     = UIColor(red: 82/255, green: 184/255, blue: 70/255, alpha: 1)
let APP_WHITE_COLOR         = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
let APP_VIOLET_COLOR        = UIColor(red: 88/255, green: 43/255, blue: 115/255, alpha: 1)
let APP_BUTTTON_UNDERLINE_BLACK_COLOR = UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 1)
let APP_LINE_HALF_OPACITY        = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1)
let APP_TEXTFILED_TEXT_PURE_BLACK_COLOR = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
let APP_TEXTFILED_UNDERLINE_COLOR = UIColor(red: 173/255, green: 173/255, blue: 173/255, alpha: 1)
let APP_TABMIDDLE_UNSELECTED_TEXT_LIGHTGRAY_COLOR = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1)

let APP_SILVER_COLOR = UIColor(red: 109/255, green: 132/255, blue: 158/255, alpha: 1)
let APP_LIGHT_BLUE_COLOR = UIColor(red: 135/255, green: 208/255, blue: 234/255, alpha: 1)
let APP_BLACK_COLOR = UIColor(red: 17/255, green: 17/255, blue: 17/255, alpha: 1)

let APP_BLUE_COLOR = #colorLiteral(red: 0.4823529412, green: 0.6823529412, blue: 1, alpha: 1)
let APP_ORANGE_COLOR = #colorLiteral(red: 1, green: 0.7333333333, blue: 0.5411764706, alpha: 1)



//MARK: - SCREEN SIZE

let NAVIGATION_BAR_HEIGHT:CGFloat = 64
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
let SCREEN_WIDTH = UIScreen.main.bounds.size.width

func GET_PROPORTIONAL_WIDTH (_ width:CGFloat) -> CGFloat {
	return ((SCREEN_WIDTH * width)/375)
}
func GET_PROPORTIONAL_HEIGHT (_ height:CGFloat) -> CGFloat {
	return ((SCREEN_HEIGHT * height)/667)
}

func GET_PROPORTIONAL_WIDTH_CELL (_ width:CGFloat) -> CGFloat {
	return ((SCREEN_WIDTH * width)/375)
}
func GET_PROPORTIONAL_HEIGHT_CELL (_ height:CGFloat) -> CGFloat {
	return ((SCREEN_WIDTH * height)/667)
}

// MARK: - KEYS FOR USERDEFAULTS

let DeviceToken = "DeviceToken"

let IS_SIGNUP = "isSignup"

// MARK: - USERDEFAULTS

func setUserDefaultValues(_ key : String , value : String)
{
    let userDefault : UserDefaults = UserDefaults.standard
    userDefault.set(value, forKey: key)
    userDefault.synchronize()
}

func setIntUserDefaultValue(_ key : String , value : Int)
{
    let userDefault : UserDefaults = UserDefaults.standard
    userDefault.set(value, forKey: key)
    userDefault.synchronize()
}

func getIntUserDefaultValue(_ key : String) -> String
{
    let userDefault : UserDefaults = UserDefaults.standard
    var value : Int = 0
    if userDefault.value(forKey: key) != nil
    {
        value = userDefault.value(forKey: key) as! Int
    }
    return String(value)
}

func getUserDefaultValue(_ key : String) -> String
{
    let userDefault : UserDefaults = UserDefaults.standard
    var value : String = ""
    if userDefault.value(forKey: key) != nil
    {
        value = userDefault.value(forKey: key) as! String
    }
    return value
}

func setBoolUserDefaultValue(_ key : String , value : Bool)
{
    let userDefault : UserDefaults = UserDefaults.standard
    userDefault.set(value, forKey: key)
    userDefault.synchronize()
}

func getBoolUserDefaultValue(_ key : String) -> Bool
{
    var value : Bool = false
    let userDefault : UserDefaults = UserDefaults.standard
    if userDefault.value(forKey: key) != nil
    {
        value = userDefault.value(forKey: key) as! Bool
    }
    return value
}

func setAttributedLabel(strString : String, lbl:UILabel)  {
    var myMutableString = NSMutableAttributedString()
    myMutableString = NSMutableAttributedString(string: strString)
    myMutableString.addAttribute(NSForegroundColorAttributeName, value: APP_LIGHT_BLUE_COLOR, range: NSRange(location:strString.characters.count - 1 ,length:1))
    lbl.attributedText = myMutableString
}
