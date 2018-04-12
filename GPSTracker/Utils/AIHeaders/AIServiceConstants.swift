//
//  AIServiceConstants.swift
//  Swift3CodeStructure
//
//  Created by Ravi Alagiya on 25/11/2016.
//  Copyright © 2016 Ravi Alagiya. All rights reserved.
//

import Foundation


//MARK:- BASE URL
let URL_BASE					= "http://secure.seowebcreative.com/"


//MARK:- URL
let URL_LOGIN                                   = getFullUrl("json_login.php")
let URL_UPDATE_LOCATION                         = getFullUrl("updatlocation.php")
let URL_TASK_LIST                               = getFullUrl("task_list1.php")
let URL_UPDATE_TASK                             = getFullUrl("update_task_status.php")


//MARK:- FULL URL

func getFullUrl(_ urlEndPoint : String) -> String {
    return URL_BASE + urlEndPoint
}

