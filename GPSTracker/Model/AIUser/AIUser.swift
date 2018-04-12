//
//  AIUser.swift
//  Swift3CodeStucture
//
//  Created by Ravi Alagiya on 11/25/16.
//  Copyright © 2016 agilepc-100. All rights reserved.
//
import Foundation

class AIUser: NSObject,NSCoding{
    
    var currentUser:AIUser!
    
    
    var ID : String = ""
    var display_name : String = ""
    var user_activation_key : String = ""
    var user_email : String = ""
    var user_login : String = ""
    var user_nicename : String = ""
    var user_pass : String = ""
    var user_registered : String = ""
    var user_status : String = ""
    var user_url : String = ""
    
    //MARK: - SHARED USER
    
    static let sharedManager : AIUser = {
        let instance = AIUser()
        if ((instance.isLoggedin()) == true) {
            instance.loadSavedUser()
        }
        return instance
    }()
    
    override init() {
        
    }
    
    public func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.ID, forKey: "ID")
        aCoder.encode(self.display_name, forKey: "display_name")
        aCoder.encode(self.user_activation_key, forKey: "user_activation_key")
        aCoder.encode(self.user_email, forKey: "user_email")
        aCoder.encode(self.user_login, forKey: "user_login")
        aCoder.encode(self.user_nicename, forKey: "user_nicename")
        aCoder.encode(self.user_pass, forKey: "user_pass")
        aCoder.encode(self.user_registered, forKey: "user_registered")
        aCoder.encode(self.user_status, forKey: "user_status")
        aCoder.encode(self.user_url, forKey: "user_url")
    }
    
    required init(coder aDecoder : NSCoder) {
        
        ID = aDecoder.decodeObject(forKey: "ID") as! String
        display_name = aDecoder.decodeObject(forKey: "display_name") as! String
        user_activation_key = aDecoder.decodeObject(forKey: "user_activation_key") as! String
        user_email = aDecoder.decodeObject(forKey: "user_email") as! String
        user_login = aDecoder.decodeObject(forKey: "user_login") as! String
        user_nicename = aDecoder.decodeObject(forKey: "user_nicename") as! String
        user_pass = aDecoder.decodeObject(forKey: "user_pass") as! String
        user_registered = aDecoder.decodeObject(forKey: "user_registered") as! String
        user_status = aDecoder.decodeObject(forKey: "user_status") as! String
        user_url = aDecoder.decodeObject(forKey: "user_url") as! String
    }
    
    func  setvalueUserWithdetails(dict : NSDictionary) -> Void {
        self.ID = dict.object_forKeyWithValidationForClass_String("ID")
        self.display_name = dict.object_forKeyWithValidationForClass_String("display_name")
        self.user_activation_key = dict.object_forKeyWithValidationForClass_String("user_activation_key")
        self.user_email = dict.object_forKeyWithValidationForClass_String("user_email")
        self.user_login = dict.object_forKeyWithValidationForClass_String("user_login")
        self.user_nicename = dict.object_forKeyWithValidationForClass_String("user_nicename")
        self.user_pass = dict.object_forKeyWithValidationForClass_String("user_pass")
        self.user_registered = dict.object_forKeyWithValidationForClass_String("user_registered")
        self.user_status = dict.object_forKeyWithValidationForClass_String("user_status")
        self.user_url = dict.object_forKeyWithValidationForClass_String("user_url")
    }
    
    //MARK: - CHECK LOGIN STATUS
    var isUserLoggedIn:Bool {
        get {
            return UserDefaults.standard.object(forKey: KEY_IS_USER_LOGGED_IN) != nil ? true : false
        }
    }
    
    func isLoggedin() -> Bool
    {
        return UserDefaults.standard.object(forKey: KEY_IS_USER_LOGGED_IN) != nil ? true : false
    }
    
    // MARK: - SAVE
    func saveInDefaults() -> Void{
        
        UserDefaults.standard.set(AIUser.sharedManager.ID, forKey: KEY_IS_USER_LOGGED_IN)
        let encodeData  = NSKeyedArchiver.archivedData(withRootObject: self)
        UserDefaults.standard.set(encodeData, forKey: AIUSER_CURRENTUSER_STORE)
        UserDefaults.standard.synchronize()
    }
    
    // MARK :- Load User
    
    func loadUser() -> AIUser? {
        let encodedObject : Data? = UserDefaults.standard.object(forKey: AIUSER_CURRENTUSER_STORE) as? Data
        if encodedObject != nil {
            
            let object : AIUser? = NSKeyedUnarchiver.unarchiveObject(with: encodedObject! as Data) as? AIUser
            return object
        }
        return nil
        
    }
    
    func loadSavedUser() -> Void {
        let objuser : AIUser? = self .loadUser()
        
        ID = (objuser?.ID)!
        display_name = (objuser?.display_name)!
        user_activation_key = (objuser?.user_activation_key)!
        user_email = (objuser?.user_email)!
        user_login = (objuser?.user_login)!
        user_nicename = (objuser?.user_nicename)!
        user_pass = (objuser?.user_pass)!
        user_registered = (objuser?.user_registered)!
        user_status = (objuser?.user_status)!
        user_url = (objuser?.user_url)!
    }
    
    // MARK: - LOGOUT
    
    func logout() -> Void {
        
        
        ID = ""
        display_name = ""
        user_activation_key = ""
        user_email = ""
        user_login = ""
        user_nicename = ""
        user_pass = ""
        user_registered = ""
        user_status = ""
        user_url = ""
        
        UserDefaults.standard.removeObject(forKey: KEY_IS_USER_LOGGED_IN)
        UserDefaults.standard.removeObject(forKey: AIUSER_CURRENTUSER_STORE)
        UserDefaults.standard.synchronize()
        AIUser.sharedManager.currentUser = nil
        
        // NEED TO RESET THE VALUES OF SHARED INSTANCE HERE
    }
}
