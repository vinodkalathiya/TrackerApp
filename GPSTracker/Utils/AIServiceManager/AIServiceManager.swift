//
//  AIServiceManager.swift
//  Swift3CodeStucture
//
//  Created by Ravi Alagiya on 11/24/16.
//  Copyright © 2016 agilepc-100. All rights reserved.
//

import Alamofire
import UIKit


class AIServiceManager: NSObject {
    
    static let sharedManager : AIServiceManager = {
        let instance = AIServiceManager()
        return instance
    }()
    
    
    
    // MARK: - ERROR HANDLING
    
    func handleError(_ errorToHandle : NSError){
        
        if(errorToHandle.domain == CUSTOM_ERROR_DOMAIN)	{
            //let dict = errorToHandle.userInfo as NSDictionary
            displayAlertWithTitle(APP_NAME, andMessage:"Something went wrong.", buttons: ["Dismiss"], completion: nil)
            
        }else if(errorToHandle.code == -1009){
            displayAlertWithTitle(APP_NAME, andMessage: "Please check your internet connection and try again.", buttons: ["Dismiss"], completion: nil)
        }
        else{
            if(errorToHandle.code == -999){
                return
            }
            displayAlertWithTitle(APP_NAME, andMessage:errorToHandle.localizedDescription, buttons: ["Dismiss"], completion:nil)
        }
    }

    
    // MARK: - ************* COMMON API METHOD **************
    // GET
    
    func callGetApi(_ url : String , completionHandler : @escaping (DataResponse<Any>) -> ())
    {
        if IS_INTERNET_AVAILABLE()
        {
            SHOW_CUSTOM_LOADER()
            Alamofire.request(url, method:.get, parameters: nil).responseJSON(completionHandler: completionHandler)
        }
        else
        {
            SHOW_INTERNET_ALERT()
        }
    }
    
    
    
    // Post
    
    func callPostApi(_ url : String, params : [String : AnyObject]?, completionHandler :@escaping (DataResponse<Any>) -> ())
    {
        if IS_INTERNET_AVAILABLE()
        {
            SHOW_CUSTOM_LOADER()
            
            Alamofire.request(url, method: .post, parameters: params).responseJSON(completionHandler: completionHandler)
        }
        else
        {
            SHOW_INTERNET_ALERT()
        }
        
    }
    
    
    func callPostApiWithoutLoader(_ url : String, params : [String : AnyObject]?, completionHandler :@escaping (DataResponse<Any>) -> ())
    {
        if IS_INTERNET_AVAILABLE()
        {
            Alamofire.request(url, method: .post, parameters: params).responseJSON(completionHandler: completionHandler)
        }
        else
        {
            SHOW_INTERNET_ALERT()
        }
        
    }

    
    // MARK: - ************* LOGIN **************
    
    func apiLoginWithParameters(_ parameters : [String : AnyObject] , completetion : @escaping (_ isSuccess:Bool) -> Void)
    {
        self.callPostApi(URL_LOGIN, params: parameters, completionHandler: { (response) -> Void in
            
            switch response.result
            {
            case.success(let Json):
                HIDE_CUSTOM_LOADER()
                print(Json)
                let dictJson = Json as! NSDictionary
                
                if (dictJson.value(forKey: "success")as! Int == 1){
                    
                    AIUser.sharedManager.setvalueUserWithdetails(dict: dictJson.value(forKey: "data") as! NSDictionary)
                    AIUser.sharedManager.saveInDefaults()
                    completetion(true)
                }else{
                    displayAlertWithMessage(dictJson.object_forKeyWithValidationForClass_String("message"))
                    completetion(false)
                }
                
            case.failure(let error):
                HIDE_CUSTOM_LOADER()
                self.handleError(error as NSError)
                completetion(false)
            }
        })
    }
    
    
    // MARK: - ************* Update Location **************
    func apiUpdateLocationWithParameters(_ parameters : [String : AnyObject] , completetion : @escaping (_ isSuccess:Bool) -> Void)
    {
        self.callPostApiWithoutLoader(URL_UPDATE_LOCATION, params: parameters, completionHandler: { (response) -> Void in
            switch response.result
            {
            case.success(let Json):
                HIDE_CUSTOM_LOADER()
                print(Json)
                let dictJson = Json as! NSDictionary
                if (dictJson.value(forKey: "success")as! Int == 1){
                    completetion(true)
                }else{
                    displayAlertWithMessage(dictJson.object_forKeyWithValidationForClass_String("message"))
                    completetion(false)
                }
                
            case.failure(let error):
                HIDE_CUSTOM_LOADER()
                self.handleError(error as NSError)
                completetion(false)
            }
        })
    }
    
    

    // MARK: - ************* Task List API  **************
    
    func apiTaskList(_ parameters : [String : AnyObject] , completetion : @escaping (_ isSuccess:Bool, _ arr:[[String : AnyObject]]) -> Void)
    {
        self.callPostApi(URL_TASK_LIST, params: parameters, completionHandler: { (response) -> Void in
            
            switch response.result
            {
            case.success(let Json):
                HIDE_CUSTOM_LOADER()
                print(Json)
                let dictJson = Json as! NSDictionary
                
                if (dictJson.value(forKey: "success")as! Int == 1){
                    let arrTaskList  = dictJson.value(forKey: "Tasks")as! [[String : AnyObject]]
                    completetion(true,arrTaskList)
                    
                }else {
                    displayAlertWithMessage(dictJson.object_forKeyWithValidationForClass_String("message"))
                    completetion(false,[NSDictionary]() as! [[String : AnyObject]])
                }
                
            case.failure(let error):
                HIDE_CUSTOM_LOADER()
                print(error.localizedDescription)
                self.handleError(error as NSError)
                completetion(false,[NSDictionary]() as! [[String : AnyObject]])
            }
        })
    }
    
    // MARK: - ************* Task List API  **************
    
    func apiUpdateTask(_ parameters : [String : AnyObject] , completetion : @escaping (_ isSuccess:Bool, _ msg: String) -> Void)
    {
        self.callPostApi(URL_UPDATE_TASK, params: parameters, completionHandler: { (response) -> Void in
            
            switch response.result
            {
            case.success(let Json):
                HIDE_CUSTOM_LOADER()
                print(Json)
                let dictJson = Json as! NSDictionary
                
                if (dictJson.value(forKey: "success")as! Int == 1){
                    completetion(true,dictJson.object_forKeyWithValidationForClass_String("message"))
                    
                }else {
                    displayAlertWithMessage(dictJson.object_forKeyWithValidationForClass_String("message"))
                    completetion(false,"")
                }
                
            case.failure(let error):
                HIDE_CUSTOM_LOADER()
                print(error.localizedDescription)
                self.handleError(error as NSError)
                completetion(false,"")
            }
        })
    }
    
}

