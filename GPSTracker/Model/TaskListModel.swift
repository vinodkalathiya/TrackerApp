//
//  TaskListModel.swift
//  GPSTracker
//
//  Created by sensussoft on 1/30/18.
//  Copyright © 2018 Sensu Soft. All rights reserved.
//

import UIKit

class TaskListModel: NSObject {

    var TaskId : String = ""
    var TaskType : String = ""
    var TaskNotes : String = ""
    var StartDate : String = ""
    var EndDate : String = ""
    var ClientId : String = ""
    var StaffId : String = ""
    
    func setData(dict:NSDictionary) {
        TaskId = dict.object_forKeyWithValidationForClass_String("TaskId")
        TaskType = dict.object_forKeyWithValidationForClass_String("TaskType")
        TaskNotes = dict.object_forKeyWithValidationForClass_String("TaskNotes")
        StartDate = dict.object_forKeyWithValidationForClass_String("StartDate")
        EndDate = dict.object_forKeyWithValidationForClass_String("EndDate")
        ClientId = dict.object_forKeyWithValidationForClass_String("ClientId")
        StaffId = dict.object_forKeyWithValidationForClass_String("StaffId")
    }
}
